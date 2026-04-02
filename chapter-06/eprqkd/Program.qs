import Std.Convert.*;
import Std.Random.*;

operation Main() : Unit {
    let result = EPRPrepareAndMeasure(false, false);
}

// Create EPR pair, Alice measures in her basis, Bob in his
// basisX: false = Z basis, true = X basis
// Returns Result[2]: [Alice's result, Bob's result]
operation EPRPrepareAndMeasure(aliceBasisX : Bool, bobBasisX : Bool) : Result[] {
    use (aliceQ, bobQ) = (Qubit(), Qubit());
    H(aliceQ);
    CNOT(aliceQ, bobQ);

    // Randomize measurement order
    mutable aliceResult = Zero;
    mutable bobResult = Zero;
    if DrawRandomBool(0.5) {
        set aliceResult = Measure([aliceBasisX ? PauliX | PauliZ], [aliceQ]);
        set bobResult = Measure([bobBasisX ? PauliX | PauliZ], [bobQ]);
    } else {
        set bobResult = Measure([bobBasisX ? PauliX | PauliZ], [bobQ]);
        set aliceResult = Measure([aliceBasisX ? PauliX | PauliZ], [aliceQ]);
    }

    ResetAll([aliceQ, bobQ]);
    return [aliceResult, bobResult];
}

// Same but Eve measures Bob's qubit before Bob
operation EPRWithEavesdropper(aliceBasisX : Bool, bobBasisX : Bool, eveBasisX : Bool) : Result[] {
    use (aliceQ, bobQ) = (Qubit(), Qubit());
    H(aliceQ);
    CNOT(aliceQ, bobQ);

    // Eve intercepts Bob's qubit
    let _ = Measure([eveBasisX ? PauliX | PauliZ], [bobQ]);

    mutable aliceResult = Zero;
    mutable bobResult = Zero;
    if DrawRandomBool(0.5) {
        set aliceResult = Measure([aliceBasisX ? PauliX | PauliZ], [aliceQ]);
        set bobResult = Measure([bobBasisX ? PauliX | PauliZ], [bobQ]);
    } else {
        set bobResult = Measure([bobBasisX ? PauliX | PauliZ], [bobQ]);
        set aliceResult = Measure([aliceBasisX ? PauliX | PauliZ], [aliceQ]);
    }

    ResetAll([aliceQ, bobQ]);
    return [aliceResult, bobResult];
}
