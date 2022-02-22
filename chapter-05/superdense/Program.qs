namespace SuperdenseCoding {

    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Main() : Unit {
        mutable successCount = 0;
        let runs = 4096;
        for run in 1..runs {
            let (alice1, alice2) = (DrawRandomBool(0.5), DrawRandomBool(0.5));
            let (bob1, bob2) = RunDenseCoding(alice1, alice2);
            set successCount += alice1 == bob1 and alice2 == bob2 ? 1 | 0;
        }

        Message("Success rate: " 
            + DoubleAsStringWithFormat(100. * IntAsDouble(successCount) / IntAsDouble(runs), "N2"));
    }

    operation RunDenseCoding(value1 : Bool, value2 : Bool) : (Bool, Bool) {
        use qubits = Qubit[2];

        // prepare the maximally entangled state |Φ⁺⟩ between qubits
        H(qubits[0]);
        CNOT(qubits[0], qubits[1]);

        Encode(value1, value2, qubits[0]);
        return Decode(qubits[0], qubits[1]);
    }

    operation Encode(value1 : Bool, value2 : Bool, qubit : Qubit) : Unit {
        if not value1 and not value2 { 
            I(qubit); 
        }
        if not value1 and value2 { 
            X(qubit); 
        }
        if value1 and not value2 { 
            Z(qubit); 
        }
        if value1 and value2 { 
            X(qubit); 
            Z(qubit); 
        }
    }

    operation Decode(qubit1 : Qubit, qubit2 : Qubit) : (Bool, Bool) {
        CNOT(qubit1, qubit2);
        H(qubit1);

        let result1 = IsResultOne(M(qubit1));
        let result2 = IsResultOne(M(qubit2));
        return (result1, result2);
    }
}