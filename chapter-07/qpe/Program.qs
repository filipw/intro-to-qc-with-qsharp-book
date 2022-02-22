namespace QPESample {

    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    @EntryPoint()
    operation Main() : Unit {
        use eigenstate = Qubit();
        
        TestPhaseEstimation(
            PrepareOracle(Z), 
            PrepareEigenState(eigenstate), 0.5);
        TestPhaseEstimation(
            PrepareOracle(S), 
            PrepareEigenState(eigenstate), 0.25);
        TestPhaseEstimation(
            PrepareOracle(T), 
            PrepareEigenState(eigenstate), 0.125);
    }

    operation TestPhaseEstimation(oracle : (Int, Qubit[]) => Unit is Adj + Ctl, eigenstate : Qubit, expectedPhase : Double) : Unit {
        let libPhase = BuiltinEstimation(eigenstate, oracle, 2);
        let manualPhase = ManualEstimation(eigenstate, oracle, 3);
        Message($"Expected: {expectedPhase}");
        Message($"Library: {libPhase}");
        Message($"Manual: {manualPhase}");
        Message("");
        Reset(eigenstate);
    }

    operation BuiltinEstimation(eigenstate : Qubit, oracle : ((Int, Qubit[]) => Unit is Adj + Ctl), precision : Int) : Double {
        use qubits = Qubit[precision];
        QuantumPhaseEstimation(DiscreteOracle(oracle), [eigenstate], BigEndian(qubits));
        let phase = IntAsDouble(MeasureInteger(LittleEndian(Reversed(qubits)))) / IntAsDouble(2^precision);
        return phase;
    }

    operation ManualEstimation(eigenstate : Qubit, oracle : ((Int, Qubit[]) => Unit is Adj + Ctl), precision : Int) : Double {
        use qubits = Qubit[precision];
        let register = LittleEndian(qubits);
            
        ApplyToEach(H, qubits);

        for i in 0 .. precision - 1 {
            Controlled oracle([qubits[i]], (2^i, [eigenstate]));
        }

        Adjoint QFTLE(register);
        let phase = IntAsDouble(MeasureInteger(register)) / IntAsDouble(2^precision);
        return phase;
    }

    operation U(op : (Qubit) => Unit is Adj + Ctl, power : Int, qubits : Qubit[]) : Unit is Adj + Ctl {
        for _ in 1 .. power {
            op(qubits[0]);
        }
    }

    function PrepareOracle(op : (Qubit) => Unit is Adj + Ctl) : ((Int, Qubit[]) => Unit is Adj + Ctl) {
        return U(op, _, _);
    }

    operation PrepareEigenState(eigenstate : Qubit) : Qubit {
        X(eigenstate);
        return eigenstate;
    }
}