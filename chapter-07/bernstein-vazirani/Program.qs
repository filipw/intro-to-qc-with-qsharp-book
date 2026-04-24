import Std.Convert.*;
import Std.Arrays.*;

operation Main() : Unit {
    let result = RunBernsteinVazirani(5, 3);
}

operation RunBernsteinVazirani(secret : Int, bitSize : Int) : Result[] {
    let secretBits = IntAsBoolArray(secret, bitSize);
    return BernsteinVazirani(bitSize, PrepareOracle(secretBits));
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
}
