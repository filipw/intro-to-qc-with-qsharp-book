import Std.Arrays.*;
import Std.Convert.*;
import Std.Math.*;

operation Main() : Unit {
    let result = RunGrover(5, 8);
}

operation RunGrover(searchTarget : Int, bitSize : Int) : Int {
    return Grover(bitSize, PrepareOracle(searchTarget));
}

operation Grover(n : Int, oracle : (Qubit[]) => Unit is Adj) : Int {
    let r = Floor(PI() / 4.0 * Sqrt(IntAsDouble(2^n)));
    use qubits = Qubit[n];

    ApplyToEach(H, qubits);

    for _ in 1..r {
        oracle(qubits);
        Diffusion(qubits);
    }

    let number = MeasureInteger(qubits);
    ResetAll(qubits);
    return number;
}

function PrepareOracle(solution : Int) : ((Qubit[]) => Unit is Adj) {
    return Oracle(solution, _);
}

operation Oracle(solution : Int, qubits : Qubit[]) : Unit is Adj {
    let n = Length(qubits);
    within {
        let markerBits = IntAsBoolArray(solution, n);
        for i in 0..n-1 {
            if not markerBits[i] {
                X(qubits[i]);
            }
        }
    } apply {
        Controlled Z(Most(qubits), Tail(qubits));
    }
}

operation Diffusion(qubits : Qubit[]) : Unit is Adj {
    within {
        ApplyToEachA(H, qubits);
        ApplyToEachA(X, qubits);
    } apply {
        Controlled Z(Most(qubits), Tail(qubits));
    }
}
