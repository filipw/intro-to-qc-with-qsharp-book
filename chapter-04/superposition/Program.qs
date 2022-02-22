namespace QubitExample {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
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
            set randomBits w/= idx <- result == One;
        }
        
        return BoolArrayAsInt(randomBits);
    }   

    operation RandomNumberNQubits(bitCount : Int) : Int {
        use qubits = Qubit[bitCount];
        ApplyToEach(H, qubits);
        
        let result = MultiM(qubits);
        return BoolArrayAsInt(ResultArrayAsBoolArray(result));
    }   

    operation RandomNumberFramework(bitCount : Int) : Int {
        use qubits = Qubit[bitCount];
        ApplyToEach(H, qubits);

        let register = LittleEndian(qubits);
        let randomNumber = MeasureInteger(register);
        return randomNumber;
    }  
}