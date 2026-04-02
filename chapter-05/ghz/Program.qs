import Std.Logical.*;

operation Main() : Unit {
    let result = QuantumGHZStrategy(false, false, false);
}

operation QuantumGHZStrategy(x : Bool, y : Bool, z : Bool) : Bool[] {
    use qubits = Qubit[3];
    H(qubits[0]);
    CNOT(qubits[0], qubits[1]);
    CNOT(qubits[1], qubits[2]);

    let basis1 = x ? PauliY | PauliX;
    let basis2 = y ? PauliY | PauliX;
    let basis3 = z ? PauliY | PauliX;

    let result = [
        Measure([basis1], [qubits[0]]) == One,
        Measure([basis2], [qubits[1]]) == One,
        Measure([basis3], [qubits[2]]) == One
    ];

    ResetAll(qubits);
    return result;
}

function ClassicalStrategy(x : Bool, y : Bool, z : Bool) : Bool[] {
    return [true, true, true];
}

// a XOR b XOR c = x OR y OR z
function CheckGameOutcome(xyz : Bool[], abc : Bool[]) : Bool {
    return Xor(abc[0], Xor(abc[1], abc[2])) == (xyz[0] or xyz[1] or xyz[2]);
}
