import Std.Convert.*;

// v2
operation Main() : Unit {
    // 8 possible secrets require 3 qubits (2^3 = 8)
    let bitSize = 3;
    for intSecret in 0..2^bitSize - 1 {
        let secret = IntAsBoolArray(intSecret, bitSize);
        let oracle = PrepareOracle(secret);
        let result = BernsteinVazirani(bitSize, oracle);
        let intResult = ResultArrayAsInt(result);

        Message($"Expected secret: {intSecret}, found secret: {intResult}");
    }
}

operation BernsteinVazirani(n : Int, oracle : ((Qubit[], Qubit) => Unit is Adj + Ctl)) : Result[] {
    use (x, y) = (Qubit[n], Qubit());
    X(y);
    ApplyToEach(H, x);
    H(y);

    oracle(x, y);

    ApplyToEach(H, x);

    let result = MeasureEachZ(x);
    ResetAll(x + [y]);
    return result;
}

function PrepareOracle(secret : Bool[]) : ((Qubit[], Qubit) => Unit is Adj + Ctl) {
    return Oracle(secret, _, _);
}

operation Oracle(secret : Bool[], x : Qubit[], y : Qubit) : Unit is Adj + Ctl {
    for i in 0..Length(x) - 1 {
        if secret[i] {
            CNOT(x[i], y);
        }
    }

    // alternative formulation 1
    // ApplyToEachCA(ApplyIfCA(_, CNOT(_, y), _), Zipped(secretArray, x));

    // alternative formulation 2
    // ApplyToEachCA(CControlledCA(CNOT(_,y)), Zipped(secretArray, x));

}

// v1: alternative variant, "self-contained"
// @EntryPoint()
operation Main2() : Unit {
    let bitSize = 3;
    // 8 possible secrets require 3 qubits (2^3 = 8)
    for intSecret in 0..7 {
        let secret = IntAsBoolArray(intSecret, bitSize);
        use (x, y) = (Qubit[bitSize], Qubit());
        X(y);
        ApplyToEach(H, x);
        H(y);

        // oracle
        for i in 0..Length(x) - 1 {
            if secret[i] {
                CNOT(x[i], y);
            }
        }

        ApplyToEach(H, x);

        let result = MeasureEachZ(x);
        ResetAll(x + [y]);
        let intResult = ResultArrayAsInt(result);

        Message($"Expected secret: {intSecret}, found secret: {intResult}");
    }
}