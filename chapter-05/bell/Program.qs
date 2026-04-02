import Std.Math.*;

operation Main() : Unit {
    let result = BellAB();
}

operation PrepareBellState(q1 : Qubit, q2 : Qubit) : Unit {
    X(q1);
    X(q2);
    H(q1);
    CNOT(q1, q2);
}

// Single-shot Bell experiment: prepare Bell state, apply rotations, measure in X basis
operation BellExperiment(angle1 : Double, angle2 : Double) : Result[] {
    use (q1, q2) = (Qubit(), Qubit());
    PrepareBellState(q1, q2);
    if angle1 != 0.0 { R1(angle1, q1); }
    if angle2 != 0.0 { R1(angle2, q2); }
    let (r1, r2) = (MResetX(q1), MResetX(q2));
    return [r1, r2];
}

// Bell inequality settings
operation BellAB() : Result[] { BellExperiment(0.0, PI() / 3.0) }
operation BellBC() : Result[] { BellExperiment(PI() / 3.0, 2.0 * PI() / 3.0) }
operation BellAC() : Result[] { BellExperiment(0.0, 2.0 * PI() / 3.0) }

// CHSH settings
operation CHSH_A1B1() : Result[] { BellExperiment(PI() / 4.0, 2.0 * PI() / 4.0) }
operation CHSH_A1B2() : Result[] { BellExperiment(PI() / 4.0, 0.0) }
operation CHSH_A2B1() : Result[] { BellExperiment(3.0 * PI() / 4.0, 2.0 * PI() / 4.0) }
operation CHSH_A2B2() : Result[] { BellExperiment(3.0 * PI() / 4.0, 0.0) }
