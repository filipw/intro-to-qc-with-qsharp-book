namespace CHSH {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Random;

    @EntryPoint()
    operation Main() : Unit {
        let classicalWinRate = RunGame(ClassicalStrategy);
        Message($"Classical win probability: " + DoubleAsStringWithFormat(classicalWinRate * 100., "N2"));

        let quantumWinRate = RunGame(QuantumStrategy);
        Message($"Quantum win probability: " + DoubleAsStringWithFormat(quantumWinRate * 100., "N2"));
    }

    operation RunGame(strategy : (Bool, Bool) => (Bool, Bool)) : Double {
        let runs = 4096;
        mutable wins = 0;

        for i in 0..runs {
            let inputA = DrawRandomBool(0.5);
            let inputB = DrawRandomBool(0.5);

            let chosenBits = strategy(inputA, inputB);
            if ((inputA and inputB) == Xor(chosenBits)) {
                set wins += 1;
            }
        }

        return IntAsDouble(wins) / IntAsDouble(runs);
    }

    operation ClassicalStrategy(inputA : Bool, inputB : Bool) : (Bool, Bool) {
        // return (0,0) irrespective of input bits
        return (false, false);
    }

    operation QuantumStrategy(inputA : Bool, inputB : Bool) : (Bool, Bool) {
        use (qubitA, qubitB) = (Qubit(), Qubit());
        X(qubitA);
        X(qubitB);
        H(qubitA);
        CNOT(qubitA, qubitB);
        
        let shouldAliceMeasureFirst = DrawRandomBool(0.6);
        if (shouldAliceMeasureFirst) {
            let resultA = MeasurementA(inputA, qubitA);
            let resultB = not MeasurementB(inputB, qubitB);
            return (resultA, resultB);
        } 
        else 
        {
            let resultB = not MeasurementB(inputB, qubitB);
            let resultA = MeasurementA(inputA, qubitA);
            return (resultA, resultB);
        }

        // let resultA = MeasurementA(inputA, qubitA);
        // let resultB = not MeasurementB(inputB, qubitB);
        // return (resultA, resultB);
    }

    operation MeasurementA(bit : Bool, q : Qubit) : Bool {
        let result = Measure([bit ? PauliX | PauliZ], [q]);
        return IsResultOne(result);

        // different way of expressing the same
        // X basis is the computational basis rotated by -π/4
        // let rotationAngle = bit ? (-2.0 * PI() / 4.0) | 0.0;
        // Ry(rotationAngle, q);
        // return MResetZ(q) == One;
    }

    operation MeasurementB(bit : Bool, q : Qubit) : Bool {
        // if bit = 0, measure in computational basis rotated by -π/8
        // if bit = 1, measure in computational basis rotated by π/8
        // this ensures win probability equal to cos²(π/8)
        let rotationAngle = bit ? (2.0 * PI() / 8.0) | (-2.0 * PI() / 8.0);
        Ry(rotationAngle, q);
        return IsResultOne(MResetZ(q));  
    }
}