operation Main() : Unit {
    let result = MeasureDefaultQubitZ();
}

operation MeasureDefaultQubitZ() : Result {
    use qubit = Qubit();
    let result = Measure([PauliZ], [qubit]);
    Reset(qubit);
    return result;
}

operation MeasureDefaultQubitX() : Result {
    use qubit = Qubit();
    let result = Measure([PauliX], [qubit]);
    Reset(qubit);
    return result;
}

operation MeasureSuperpositionQubitZ() : Result {
    use qubit = Qubit();
    H(qubit);
    let result = Measure([PauliZ], [qubit]);
    Reset(qubit);
    return result;
}

operation MeasureSuperpositionQubitX() : Result {
    use qubit = Qubit();
    H(qubit);
    let result = Measure([PauliX], [qubit]);
    Reset(qubit);
    return result;
}
