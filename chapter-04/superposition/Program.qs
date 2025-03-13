import Std.Convert.*;

operation Main() : Unit {
    let rnd1 = RandomNumber1Qubit(8);
    Message($"Random uint8 using single qubit: {rnd1}");

    let rnd2 = RandomNumberNQubits(8);
    Message($"Random uint8 using multiple qubits: {rnd2}");

    let rnd3 = RandomNumberFramework(8);
    Message($"Random uint8 using framework features: {rnd3}");
}

operation RandomNumber1Qubit(bitCount : Int) : Int {
    mutable randomBits = [false, size = bitCount]; // 000...0

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