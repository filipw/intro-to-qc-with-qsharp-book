operation Main() : Unit {
    let result = RunDenseCoding(true, false);
}

operation RunDenseCoding(value1 : Bool, value2 : Bool) : (Bool, Bool) {
    use qubits = Qubit[2];

    // prepare the maximally entangled state |Phi+> between qubits
    H(qubits[0]);
    CNOT(qubits[0], qubits[1]);

    Encode(value1, value2, qubits[0]);
    return Decode(qubits[0], qubits[1]);
}

operation Encode(value1 : Bool, value2 : Bool, qubit : Qubit) : Unit {
    if not value1 and not value2 {
        I(qubit);
    }
    if not value1 and value2 {
        X(qubit);
    }
    if value1 and not value2 {
        Z(qubit);
    }
    if value1 and value2 {
        X(qubit);
        Z(qubit);
    }
}

operation Decode(qubit1 : Qubit, qubit2 : Qubit) : (Bool, Bool) {
    CNOT(qubit1, qubit2);
    H(qubit1);

    let result1 = M(qubit1) == One;
    let result2 = M(qubit2) == One;
    ResetAll([qubit1, qubit2]);
    return (result1, result2);
}
