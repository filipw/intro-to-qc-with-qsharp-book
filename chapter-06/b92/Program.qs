namespace B92 {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Start() : Unit {
        RunB92Protocol(64, 16, 1.0);
        RunB92Protocol(64, 16, 0.5);
        RunB92Protocol(64, 16, 0.0);
    }

    operation RunB92Protocol(roundtrips : Int, rountripSize : Int, eavesdropperProbability : Double) : Unit {
        mutable aliceKey = [false, size = 0];
        mutable bobKey = [false, size = 0];

        for roundtrip in 0..roundtrips-1 {
            use qubits = Qubit[rountripSize];
                
            // 1. Alice chooses her random bits 
            let aliceValues = GenerateRandomBitArray(rountripSize);

            // 2. Alice encodes the values in the qubits using the random bases 
            EncodeQubits(aliceValues, qubits);

            // 3. Eve attempts to evesdrop based on the configurable probability
            Eavesdrop(eavesdropperProbability, qubits);

            // 4. Bob chooses his bases
            let bobBases = GenerateRandomBitArray(rountripSize);

            // 5. Bob measures qubits using the random bases
            let bobResults = DecodeQubits(bobBases, qubits);

            // 6. Alice and Bob perform the comparison and throw away unnecessary values
            let (aliceRoundTripResult, bobRoundTripResult) 
                = ReconcileAliceAndBob(rountripSize, aliceValues, bobBases, bobResults);

            // 7. Append both key from this roundtrip to the overall key
            // repeat however many times needed 
            set aliceKey += aliceRoundTripResult;
            set bobKey += bobRoundTripResult;

            ResetAll(qubits);
        }
        
        // 8. Perform the eavesdropper check
        let (errorRate, trimmedAliceKey, trimmedBobKey) = EavesdropperCheck(aliceKey, bobKey);

        // 9. Output the resulting keys and additional useful info
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

    operation EncodeQubits(bits : Bool[], qubits : Qubit[]) : Unit {
        for i in 0..Length(qubits)-1 {
            let valueSelected = bits[i];
            if (valueSelected) { H(qubits[i]); }
        }
    }

    operation DecodeQubits(bases : Bool[], qubits : Qubit[]) : Bool[] {
        mutable bits = [];

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

    function ReconcileAliceAndBob(length : Int, bitsAlice : Bool[], basesBob : Bool[], bitsBob : Bool[]) : (Bool[], Bool[]) {
        mutable aliceTrimmedBits = [];
        mutable bobTrimmedBits = [];

        for i in 0..length-1 {
            let r = bitsBob[i];
            let a = bitsAlice[i];
            let b = basesBob[i];

            if r {
                set aliceTrimmedBits += [a];
                set bobTrimmedBits += [not b];
            }
        }

        return (aliceTrimmedBits, bobTrimmedBits);
    }

    operation EavesdropperCheck(aliceKey : Bool[], bobKey : Bool[]) : (Double, Bool[], Bool[]) {
        mutable trimmedAliceKey = [];
        mutable trimmedBobKey = [];
        mutable eavesdropperIndices = [];

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
        Message($"Alice's key: {BoolArrayAsBigInt(aliceBits)} | key length: {Length(aliceBits)}");
        Message($"Bob's key:   {BoolArrayAsBigInt(bobBits)} | key length: {Length(bobBits)}");

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