import Std.Convert.*;

operation Main() : Unit {
    let rnd = RandomNumber1Qubit(8);
}

operation RandomNumber1Qubit(bitCount : Int) : Int {
    mutable randomBits = [false, size = bitCount];

    for idx in 0..bitCount-1 {
        use qubit = Qubit();
        H(qubit);
        let result = M(qubit);
        Reset(qubit);
        set randomBits w/= idx <- result == One;
    }

    return BoolArrayAsInt(randomBits);
}

operation RandomNumberNQubits(bitCount : Int) : Int {
    use qubits = Qubit[bitCount];
    ApplyToEach(H, qubits);

    let result = MeasureEachZ(qubits);
    ResetAll(qubits);
    return BoolArrayAsInt(ResultArrayAsBoolArray(result));
}

operation RandomNumberFramework(bitCount : Int) : Int {
    use qubits = Qubit[bitCount];
    ApplyToEach(H, qubits);

    let randomNumber = MeasureInteger(qubits);
    ResetAll(qubits);
    return randomNumber;
}
