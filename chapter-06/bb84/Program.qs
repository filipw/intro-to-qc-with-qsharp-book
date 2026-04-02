import Std.Convert.*;

operation Main() : Unit {
    let result = BB84PrepareAndMeasure(true, false, false);
}

// Prepare a qubit with sender's value/basis, measure in receiver's basis
// basisX: false = Z basis, true = X basis
operation BB84PrepareAndMeasure(senderValue : Bool, senderBasisX : Bool, receiverBasisX : Bool) : Result {
    use qubit = Qubit();
    if senderValue { X(qubit); }
    if senderBasisX { H(qubit); }
    let result = Measure([receiverBasisX ? PauliX | PauliZ], [qubit]);
    Reset(qubit);
    return result;
}

// Same as above but Eve measures in between
operation BB84WithEavesdropper(senderValue : Bool, senderBasisX : Bool, eveBasisX : Bool, receiverBasisX : Bool) : Result {
    use qubit = Qubit();
    if senderValue { X(qubit); }
    if senderBasisX { H(qubit); }

    // Eve intercepts
    let _ = Measure([eveBasisX ? PauliX | PauliZ], [qubit]);

    let result = Measure([receiverBasisX ? PauliX | PauliZ], [qubit]);
    Reset(qubit);
    return result;
}
