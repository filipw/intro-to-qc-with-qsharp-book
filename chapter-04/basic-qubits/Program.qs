namespace Basic {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Main() : Unit {
        // measurement in Z basis should produce |0> 100% of time 
        Message("Measuring default qubits in Z basis");
        Sample(4096, PauliZ, MeasureDefaultQubit);

        // measurement in X basis should produce |0> 50% of time
        // and |1> the other 50% of time
        Message("Measuring default qubits in X basis");
        Sample(4096, PauliX, MeasureDefaultQubit);

        // measurement in Z basis should produce |0> 50% of time
        // and |1> the other 50% of time
        Message("Measuring Z-basis superposition in the Z basis");
        Sample(4096, PauliZ, MeasureSuperpositionQubit);

        // measurement in X basis should produce |0> 100% of time 
        Message("Measuring Z-basis superposition in the X basis");
        Sample(4096, PauliX, MeasureSuperpositionQubit);
    }

    operation AllocateQubits() : Unit {
        // borrow is used the same way
        use qubit = Qubit();
        Reset(qubit);

        use twoQubits = Qubit[2];
        ResetAll(twoQubits);

        use (qubit1, qubit2) = (Qubit(), Qubit());
        ResetAll([qubit1, qubit2]);
    }    

    operation MeasureDefaultQubit(basis : Pauli) : Result {
        use qubit = Qubit();
        let result = Measure([basis], [qubit]);

        // an alternative basis specific measurements with a built-in reset:
        // MResetZ(qubit) 
        // MResetX(qubit)
        return result;
    }

    operation MeasureSuperpositionQubit(basis : Pauli) : Result {
        use qubit = Qubit();
        H(qubit);
        let result = Measure([basis], [qubit]);
        return result;
    }

    operation Sample(iterations : Int, basis : Pauli, op: (Pauli => Result)) : Unit {
        mutable runningTotal = 0;
        for idx in 1..iterations {
            let result = op(basis);
            set runningTotal += result == One ? 1 | 0;
        }

        Message($"Measurement results:");
        Message($"|0>: {iterations - runningTotal}");
        Message($"|1>: {runningTotal}");
    }
}