namespace QubitExample {

    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Main() : Unit {
        Message("Measuring I");
        Sample(4096, MeasureI);

        Message("Measuring X");
        Sample(4096, MeasureX);
        
        Message("Testing Z against |0>");
        TestZAgainst0();
        
        Message("Testing Z against |1>");
        TestZAgainst1();
        
        Message("Testing Y against |0>");
        TestYAgainst0();
        
        Message("Testing Y against |1>");
        TestYAgainst1();
        
        Message("Measuring HZH");
        Sample(4096, MeasureHZH);
        
        Message("Testing S against |1>");
        TestSAgainst1();
        
        Message("Testing S reversibility");
        TestSReversibility();
        
        Message("Testing T - Z relationship");
        TestTZRelationship();
    }

    operation Sample(iterations : Int, op: (Unit => Result)) : Unit {
        mutable runningTotal = 0;
        for idx in 0..iterations-1 {
            let result = op();
            set runningTotal += result == One ? 1 | 0;
        }

        Message($"Measurement results:");
        Message($"Result 0: {iterations - runningTotal}");
        Message($"Result 1: {runningTotal}");
    }

    operation MeasureI() : Result {
        use qubit = Qubit();
        I(qubit);
        let result = MResetZ(qubit);
        Reset(qubit);
        return result;
    }

    operation MeasureX() : Result {
        use qubit = Qubit();
        X(qubit);
        let result = MResetX(qubit);
        return result;
    }

    operation MeasureHZH() : Result {
        use qubit = Qubit();
        H(qubit);
        Z(qubit);
        H(qubit);
        let result = MResetZ(qubit);
        return result;
    }

    operation TestZAgainst0() : Unit {
        use qubit = Qubit();
        Z(qubit);
        DumpMachine();
        Reset(qubit);
    }

    operation TestZAgainst1() : Unit {
        use qubit = Qubit();
        X(qubit);
        Z(qubit);
        DumpMachine();
        Reset(qubit);
    }

    operation TestYAgainst0() : Unit {
        use qubit = Qubit();
        Y(qubit);
        DumpMachine();
        Reset(qubit);
    }

    operation TestYAgainst1() : Unit {
        use qubit = Qubit();
        X(qubit);
        Y(qubit);
        DumpMachine();
        Reset(qubit);
    }

    operation TestSAgainst1() : Unit {
        use qubit = Qubit();
        X(qubit);
        S(qubit);
        DumpMachine();
        Reset(qubit);
    }

    operation TestSReversibility() : Unit {
        use qubit = Qubit();
        X(qubit);
        S(qubit);
        Adjoint S(qubit);
        DumpMachine();
        Reset(qubit);
    }

    operation TestTZRelationship() : Unit {
        use qubit = Qubit();
        X(qubit);

        T(qubit);
        T(qubit);
        T(qubit);
        T(qubit);
        DumpMachine();
        Reset(qubit);
    }
}