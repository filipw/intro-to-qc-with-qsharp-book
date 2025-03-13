import Std.Convert.*;

operation Main() : Unit {

    mutable matchingMeasurement = 0;
    mutable res = [0, 0, 0, 0];

    for i in 1..4096 {

        let (c1, c3) = EnganglementSwapping();

        if (not c1 and not c3) {
            set res w/= 0 <- res[0] + 1;
        }
        if (not c1 and c3) {
            set res w/= 1 <- res[1] + 1;
        }
        if (c1 and not c3) {
            set res w/= 2 <- res[2] + 1;
        }
        if (c1 and c3) {
            set res w/= 3 <- res[3] + 1;
        }
        if (c1 == c3) {
            set matchingMeasurement += 1;
        }
    }

    Message($"Measured |00>: {res[0]}");
    Message($"Measured |01>: {res[1]}");
    Message($"Measured |10>: {res[2]}");
    Message($"Measured |11>: {res[3]}");
    Message($"Measurements of qubits 1 and 3 matched: {matchingMeasurement}");
}

operation EnganglementSwapping() : (Bool, Bool) {

    // Alice
    use (q1, q2) = (Qubit(), Qubit());
    H(q1);
    CNOT(q1, q2);
    // at this point Alice has an entangled pair q1, q2 = |00⟩+|11⟩/√2

    // Bob
    use (q3, q4) = (Qubit(), Qubit());
    H(q3);
    CNOT(q3, q4);
    // at this point Bob has an entangled pair q3, q4 = |00⟩+|11⟩/√2

    // Bell measurement - done by Carol
    CNOT(q2, q4);
    H(q2);
    let q2Result = M(q2);
    let q4Result = M(q4);

    // at this point q1 and q3 are entangled, but in one of the four possible Bell states
    // Bob needs to fix up the state between q1 and q3 to become |00⟩+|11⟩/√2
    if (q2Result == Zero and q4Result == Zero) {
        I(q3);
    }

    if (q2Result == Zero and q4Result == One) {
        X(q3);
    }

    if (q2Result == One and q4Result == Zero) {
        Z(q3);
    }

    if (q2Result == One and q4Result == One) {
        X(q3);
        Z(q3);
    }

    // optional - this will return qubits to state |00⟩
    //Adjoint PrepareEntangledState(q1, q3);

    // at this point the entangled pair q1, q3 is |00⟩+|11⟩/√2
    let c1 = ResultAsBool(M(q1));
    let c3 = ResultAsBool(M(q3));

    ResetAll([q1, q2, q3, q4]);

    return (c1, c3);
}

operation PrepareEntangledState(left : Qubit, right : Qubit) : Unit is Adj + Ctl {
    H(left);
    CNOT(left, right);
}