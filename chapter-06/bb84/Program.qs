namespace BB84 {

    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Start() : Unit {
        RunBB84Protocol(32, 16, 1.0);
        RunBB84Protocol(32, 16, 0.5);
        RunBB84Protocol(32, 16, 0.0);
    }

    operation RunBB84Protocol(roundtrips : Int, rountripSize : Int, eavesdropperProbability : Double) : Unit {
        mutable aliceKey = [false, size = 0];
        mutable bobKey = [false, size = 0];

        for roundtrip in 0..roundtrips-1 {
            use qubits = Qubit[rountripSize];
                
            // 1. Alice chooses her bases 
            let aliceBases = GenerateRandomBitArray(rountripSize);

            // 2. Alice chooses her random bits 
            let aliceValues = GenerateRandomBitArray(rountripSize);

            // 3. Alice encodes the values in the qubits using the random bases 
            EncodeQubits(aliceValues, aliceBases, qubits);

            // 4. Eve attempts to evesdrop based on the configurable probability
            Eavesdrop(eavesdropperProbability, qubits);

            // 5. Bob chooses his bases
            let bobBases = GenerateRandomBitArray(rountripSize);

            // 6. Bob measures qubits using the random bases
            let bobResults = DecodeQubits(bobBases, qubits);

            // 7. Alice and Bob compare their bases and throw away those values that were encoded/decode in non-matching bases
            let (aliceRoundTripResult, bobRoundTripResult) 
                = CompareBases(rountripSize, aliceBases, aliceValues, bobBases, bobResults);

            // 8. Append both key from this roundtrip to the overall key
            // repeat however many times needed 
            set aliceKey += aliceRoundTripResult;
            set bobKey += bobRoundTripResult;
        }
        
        // 9. Perform the eavesdropper check
        let (errorRate, trimmedAliceKey, trimmedBobKey) = EavesdropperCheck(aliceKey, bobKey);

        // 10. Output the resulting keys and additional useful info
        ProcessResults(errorRate, trimmedAliceKey, trimmedBobKey, eavesdropperProbability);
    }

    operation GenerateRandomBitArray(length : Int) : Bool[] {
        mutable bits = [false, size = length];

        for i in 0..length-1 {
            let randomBit = DrawRandomBool(0.5);
            set bits w/= i <- randomBit;
        }

        return bits;
    }

    operation EncodeQubits(bits : Bool[], bases : Bool[], qubits : Qubit[]) : Unit {
        for i in 0..Length(qubits)-1 {
            let valueSelected = bits[i];
            if (valueSelected) { X(qubits[i]); }

            // 0 will represent |0> and |1> computational (PauliZ) basis
            // 1 will represent |-> and |+> Hadamard (PauliX) basis
            let basisSelected = bases[i];
            if (basisSelected) { H(qubits[i]); }
        }
    }

    operation DecodeQubits(bases : Bool[], qubits : Qubit[]) : Bool[] {
        mutable bits = [false, size = 0];

        for i in 0..Length(qubits)-1 {
            let result = Measure([bases[i] ? PauliX | PauliZ], [qubits[i]]);
            set bits += [ResultAsBool(result)];
        }

        return bits;
    }

    operation Eavesdrop(eavesdropperProbability : Double, qubits : Qubit[]) : Unit {
        for qubit in qubits {
            let shouldEavesdrop = DrawRandomBool(eavesdropperProbability);
            if (shouldEavesdrop) {
                let eveBasisSelected = DrawRandomBool(0.5);
                let eveResult = Measure([eveBasisSelected ? PauliX | PauliZ], [qubit]);
            }
        }
    }

    function CompareBases(length : Int, basesAlice : Bool[], bitsAlice : Bool[], basesBob : Bool[], bitsBob : Bool[]) : (Bool[], Bool[]) {
        mutable trimmedAliceBits = [false, size = 0];
        mutable trimmedBobBits = [false, size = 0];

        // compare bases and pick shared results
        for i in 0..length-1 {
            // if Alice and Bob used the same basis
            // they can use the corresponding bit
            if (basesAlice[i] == basesBob[i]) {
                set trimmedAliceBits += [bitsAlice[i]];
                set trimmedBobBits += [bitsBob[i]];
            }
        }

        return (trimmedAliceBits, trimmedBobBits);
    }

    operation EavesdropperCheck(aliceKey : Bool[], bobKey : Bool[]) : (Double, Bool[], Bool[]) {
        mutable trimmedAliceKey = [false, size = 0];
        mutable trimmedBobKey = [false, size = 0];
        mutable eavesdropperIndices = [0, size = 0];

        for i in 0..Length(aliceKey)-1 {
            let applyCheck = DrawRandomBool(0.5);
            if (applyCheck) {
                set eavesdropperIndices += [i];
            } else {
                set trimmedAliceKey += [aliceKey[i]];
                set trimmedBobKey += [bobKey[i]];
            }
        }

        mutable differences = 0;
        for i in eavesdropperIndices {
            // if Alice and Bob get different result, but used same basis
            // it means that there must have been an eavesdropper (assuming perfect communication)
            if (aliceKey[i] != bobKey[i]) {
                set differences += 1;
            }
        }
        let errorRate = IntAsDouble(differences)/IntAsDouble(Length(eavesdropperIndices));
        return (errorRate, trimmedAliceKey, trimmedBobKey);
    }

    function ProcessResults(errorRate : Double, aliceBits : Bool[], bobBits : Bool[], eavesdropperProbability : Double) : Unit {
        Message($"Alice's key: {BoolArrayAsBigInt(aliceBits)} | key length: {IntAsString(Length(aliceBits))}");
        Message($"Bob's key:   {BoolArrayAsBigInt(bobBits)} | key length: {IntAsString(Length(bobBits))}");

        Message($"Error rate: {errorRate * IntAsDouble(100)}%");
        if (errorRate > 0.0) {
            Message($"Eavesdropper detected!");
        }

        if (EqualA(EqualB, aliceBits, bobBits)) {
            Message($"Running the protocol with eavesdropping probability {eavesdropperProbability} was successful.");
        } else {
            Message($"Running the protocol with eavesdropping probability {eavesdropperProbability} was unsuccessful.");
        }

        Message("");
    }
}