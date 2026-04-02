import Std.Convert.*;

operation Main() : Unit {
    let result = EntanglementSwapping();
}

operation EntanglementSwapping() : Result[] {
    // Alice
    use (q1, q2) = (Qubit(), Qubit());
    H(q1);
    CNOT(q1, q2);

    // Bob
    use (q3, q4) = (Qubit(), Qubit());
    H(q3);
    CNOT(q3, q4);

    // Bell measurement - done by Carol
    CNOT(q2, q4);
    H(q2);
    let q2Result = M(q2);
    let q4Result = M(q4);

    // Fix up the state between q1 and q3
    if q2Result == Zero and q4Result == Zero {
        I(q3);
    }
    if q2Result == Zero and q4Result == One {
        X(q3);
    }
    if q2Result == One and q4Result == Zero {
        Z(q3);
    }
    if q2Result == One and q4Result == One {
        X(q3);
        Z(q3);
    }

    // Measure the now-entangled pair q1, q3
    let r1 = M(q1);
    let r3 = M(q3);
    ResetAll([q1, q2, q3, q4]);
    return [r1, r3];
}
