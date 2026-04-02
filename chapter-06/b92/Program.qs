import Std.Convert.*;

operation Main() : Unit {
    let result = B92PrepareAndMeasure(true, false);
}

// B92 encoding: value=false -> |0> (Z basis), value=true -> |+> (X basis)
// Receiver measures in chosen basis
operation B92PrepareAndMeasure(senderValue : Bool, receiverBasisX : Bool) : Result {
    use qubit = Qubit();
    if senderValue { H(qubit); }
    let result = Measure([receiverBasisX ? PauliX | PauliZ], [qubit]);
    Reset(qubit);
    return result;
}

// Same but Eve intercepts
operation B92WithEavesdropper(senderValue : Bool, eveBasisX : Bool, receiverBasisX : Bool) : Result {
    use qubit = Qubit();
    if senderValue { H(qubit); }

    // Eve intercepts
    let _ = Measure([eveBasisX ? PauliX | PauliZ], [qubit]);

    let result = Measure([receiverBasisX ? PauliX | PauliZ], [qubit]);
    Reset(qubit);
    return result;
}
