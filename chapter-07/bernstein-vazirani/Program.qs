import Std.Convert.*;
import Std.Arrays.*;

operation Main() : Unit {
    let result = RunBernsteinVazirani(5, 3);
}

operation RunBernsteinVazirani(secret : Int, bitSize : Int) : Result[] {
    let secretBits = IntAsBoolArray(secret, bitSize);
    use (x, y) = (Qubit[bitSize], Qubit());
    X(y);
    ApplyToEach(H, x);
    H(y);

    // oracle
    for i in 0..Length(x) - 1 {
        if secretBits[i] {
            CNOT(x[i], y);
        }
    }

    ApplyToEach(H, x);

    let result = MeasureEachZ(x);
    ResetAll(x + [y]);
    return result;
}
