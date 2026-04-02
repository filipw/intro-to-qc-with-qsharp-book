import Std.Diagnostics.*;

operation Main() : Unit {
    let result = MeasureI();
}

operation MeasureI() : Result {
    use qubit = Qubit();
    I(qubit);
    return MResetZ(qubit);
}

operation MeasureX() : Result {
    use qubit = Qubit();
    X(qubit);
    return MResetZ(qubit);
}

operation MeasureHZH() : Result {
    use qubit = Qubit();
    H(qubit);
    Z(qubit);
    H(qubit);
    return MResetZ(qubit);
}

// State inspection operations - apply gate(s) and dump, then reset

operation DumpZ0() : Unit {
    use q = Qubit();
    Z(q);
    DumpMachine();
    Reset(q);
}

operation DumpZ1() : Unit {
    use q = Qubit();
    X(q);
    Z(q);
    DumpMachine();
    Reset(q);
}

operation DumpY0() : Unit {
    use q = Qubit();
    Y(q);
    DumpMachine();
    Reset(q);
}

operation DumpY1() : Unit {
    use q = Qubit();
    X(q);
    Y(q);
    DumpMachine();
    Reset(q);
}

operation DumpS1() : Unit {
    use q = Qubit();
    X(q);
    S(q);
    DumpMachine();
    Reset(q);
}

operation DumpSAdjS1() : Unit {
    use q = Qubit();
    X(q);
    S(q);
    Adjoint S(q);
    DumpMachine();
    Reset(q);
}

operation DumpT4on1() : Unit {
    use q = Qubit();
    X(q);
    T(q);
    T(q);
    T(q);
    T(q);
    DumpMachine();
    Reset(q);
}
