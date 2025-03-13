import Std.Logical.*;

operation Main() : Unit {

    let xyz = [
        [false, false, false],
        [false, true, true],
        [true, false, true],
        [true, true, false]
    ];

    mutable qStrategyWins = 0;
    mutable cStrategyWins = 0;

    for refBits in xyz {
        mutable qStrategyRoundWins = 0;
        mutable cStrategyRoundWins = 0;
        for _ in 1..128 {
            let qOutput = QuantumGHZStrategy(refBits[0], refBits[1], refBits[2]);
            let qGameResult = CheckGameOutcome(refBits, qOutput);
            set qStrategyWins += qGameResult ? 1 | 0;
            set qStrategyRoundWins += qGameResult ? 1 | 0;

            let cOutput = ClassicalStrategy(refBits[0], refBits[1], refBits[2]);
            let cGameResult = CheckGameOutcome(refBits, cOutput);
            set cStrategyWins += cGameResult ? 1 | 0;
            set cStrategyRoundWins += cGameResult ? 1 | 0;
        }
        Message($"For input: {refBits} Quantum GHZ strategy won: {cStrategyRoundWins} times.");
        Message($"For input: {refBits} Classical strategy won: {cStrategyRoundWins} times.");
    }
    Message($"Quantum GHZ strategy won: {qStrategyWins * 100 / 512}%.");
    Message($"Classical strategy won  : {cStrategyWins * 100 / 512}%.");
}

operation QuantumGHZStrategy(x : Bool, y : Bool, z : Bool) : Bool[] {
    use qubits = Qubit[3];
    H(qubits[0]);
    CNOT(qubits[0], qubits[1]);
    CNOT(qubits[1], qubits[2]);

    let basis1 = x ? PauliY | PauliX;
    let basis2 = y ? PauliY | PauliX;
    let basis3 = z ? PauliY | PauliX;

    let result = [Measure([basis1], [qubits[0]]) == One, Measure([basis2], [qubits[1]]) == One, Measure([basis3], [qubits[2]]) == One];

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