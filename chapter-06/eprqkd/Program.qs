namespace EPRQKD {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Start() : Unit {
        RunEPRQKDProtocol(128, 0.0);
        RunEPRQKDProtocol(128, 0.5);
        RunEPRQKDProtocol(128, 1.0);
    }

    operation RunEPRQKDProtocol(expectedKeyLength : Int, eavesdropperProbability : Double) : Unit {
        // we require 4 * n EPR pairs to produce a key of length n (on average)
        let requiredQubits = 4 * expectedKeyLength;
        mutable aliceResults = [false, size = 0];
        mutable bobResults = [false, size = 0];

        // 1. Alice and Bob choose their bases 
        let aliceBases = GenerateRandomBitArray(requiredQubits);
        let bobBases = GenerateRandomBitArray(requiredQubits);

        for i in 0..requiredQubits-1 {

            // 2. create an entangled EPR pair
            use (aliceQ, bobQ) = (Qubit(), Qubit());
            H(aliceQ);
            CNOT(aliceQ, bobQ);

            // 3. Eve attempts to evesdrop based on the configurable probability
            Eavesdrop(eavesdropperProbability, [bobQ]);

            // 4 Alice and Bob measure in their random bases
            // Randomize who measures first
            if (DrawRandomBool(0.5)) {
                set aliceResults += [DoMeasure(aliceBases[i], aliceQ)];
                set bobResults += [DoMeasure(bobBases[i], bobQ)];
            } else {
                set bobResults += [DoMeasure(bobBases[i], bobQ)];
                set aliceResults += [DoMeasure(aliceBases[i], aliceQ)];
            }

            ResetAll([aliceQ, bobQ]);
        }
        
        // 5. Compare bases
        let (aliceKey, bobKey) 
            = CompareBases(aliceBases, aliceResults, bobBases, bobResults);

        // 6. Perform the eavesdropper check
        let (errorRate, trimmedAliceKey, trimmedBobKey) = EavesdropperCheck(aliceKey, bobKey);

        // 7. Output the resulting keys and additional useful info
        ProcessResults(errorRate, trimmedAliceKey, trimmedBobKey, eavesdropperProbability);
    }

    operation DoMeasure(basisBit : Bool, qubit : Qubit) : Bool {
        // - 0 will represent {|0>,|1>} computational (PauliZ) basis
        // - 1 will represent {|->,|+>} Hadamard (PauliX) basis
        let result = Measure([basisBit ? PauliX | PauliZ], [qubit]);
        let classicalResult = ResultAsBool(result);
        return classicalResult;
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
        Message($"Alice's key as int: {BoolArrayAsBigInt(aliceBits)} | key length: {Length(aliceBits)}");
        Message($"Bob's key as int:   {BoolArrayAsBigInt(bobBits)} | key length: {Length(bobBits)}");

        Message($"Error rate: {errorRate * IntAsDouble(100)}%");
        if (errorRate > 0.0) {
            Message($"Eavesdropper detected!");
        }

        if aliceBits == bobBits {
            Message($"Running the protocol with eavesdropping probability {eavesdropperProbability} was successful.");
        } else {
            Message($"Running the protocol with eavesdropping probability {eavesdropperProbability} was unsuccessful.");
        }

        Message("");
    }

    function CompareBases(basesAlice : Bool[], bitsAlice : Bool[], basesBob : Bool[], bitsBob : Bool[]) : (Bool[], Bool[]) {
        mutable trimmedAliceBits = [false, size = 0];
        mutable trimmedBobBits = [false, size = 0];

        // compare bases and pick shared results
        for i in 0..Length(bitsAlice)-1 {
            // if Alice and Bob used the same basis
            // they can use the corresponding bit
            if (basesAlice[i] == basesBob[i]) {
                set trimmedAliceBits += [bitsAlice[i]];
                set trimmedBobBits += [bitsBob[i]];
            }
        }

        return (trimmedAliceBits, trimmedBobBits);
    }

    operation GenerateRandomBitArray(length : Int) : Bool[] {
        mutable bits = [false, size = length];

        for i in 0..length-1 {
            let randomBit = DrawRandomBool(0.5);
            set bits w/= i <- randomBit;
        }

        return bits;
    }

    operation DrawRandomBool(successProbability: Double) : Bool {
        let randomValue = DrawRandomDouble(0.0, 1.0);
        return randomValue < successProbability;
    }

    function BoolArrayAsBigInt(boolArray : Bool[]) : BigInt {
        mutable result = 0L;
        for i in 0..Length(boolArray) - 1 {
            if (boolArray[i]) {
                set result += 1L <<< i;
            }
        }
        return result;
    }
}