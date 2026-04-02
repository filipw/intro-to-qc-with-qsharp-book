import Std.Arrays.*;
import Std.Convert.*;
import Std.Math.*;

operation Main() : Unit {
    let result = RunGrover(5, 8);
}

operation RunGrover(searchTarget : Int, bitSize : Int) : Int {
    let r = Floor(PI() / 4.0 * Sqrt(IntAsDouble(2^bitSize)));
    use qubits = Qubit[bitSize];

    ApplyToEach(H, qubits);

    for _ in 1..r {
        Oracle(searchTarget, qubits);
        Diffusion(qubits);
    }

    let number = MeasureInteger(qubits);
    ResetAll(qubits);
    return number;
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
