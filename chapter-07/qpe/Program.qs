import Std.Diagnostics.*;
import Std.Arrays.*;
import Std.Convert.*;
import Std.Canon.*;

operation Main() : Unit {
    //
    // uncomment the one desired to run
    //
    // RunManualEstimation();
    // RunBuiltinEstimation();
}

operation RunManualEstimation() : Unit {
    use eigenstate = Qubit();
    TestPhaseEstimation(ManualEstimation, eigenstate, PrepareOracle(Z), 0.5);
    TestPhaseEstimation(ManualEstimation, eigenstate, PrepareOracle(S), 0.25);
    TestPhaseEstimation(ManualEstimation, eigenstate, PrepareOracle(T), 0.125);
}

operation RunBuiltinEstimation() : Unit {
    use eigenstate = Qubit();
    TestPhaseEstimation(BuiltinEstimation, eigenstate, PrepareOracle(Z), 0.5);
    TestPhaseEstimation(BuiltinEstimation, eigenstate, PrepareOracle(S), 0.25);
    TestPhaseEstimation(BuiltinEstimation, eigenstate, PrepareOracle(T), 0.125);
}

operation TestPhaseEstimation(estimator : (Qubit, (Int, Qubit[]) => Unit is Adj + Ctl, Int) => Double, eigenstate : Qubit, oracle : (Int, Qubit[]) => Unit is Adj + Ctl, expectedPhase : Double) : Unit {
    PrepareEigenState(eigenstate);
    let phase = estimator(eigenstate, oracle, 3);
    Message($"Expected: {expectedPhase}, estimated: {phase}");
    Reset(eigenstate);
}

operation BuiltinEstimation(eigenstate : Qubit, oracle : ((Int, Qubit[]) => Unit is Adj + Ctl), precision : Int) : Double {
    use phaseRegister = Qubit[precision];
    ApplyQPE(oracle, [eigenstate], phaseRegister);
    let phase = IntAsDouble(MeasureInteger(phaseRegister)) / IntAsDouble(2^precision);
    return phase;
}

operation ManualEstimation(eigenstate : Qubit, oracle : ((Int, Qubit[]) => Unit is Adj + Ctl), precision : Int) : Double {
    use qubits = Qubit[precision];
    ApplyToEachCA(H, qubits);

    for i in 0..precision - 1 {
        let power = 2^((precision - i) - 1);
        Controlled oracle([qubits[i]], (power, [eigenstate]));
    }

    Adjoint ApplyQFT(qubits);

    let phase = IntAsDouble(MeasureInteger(qubits)) / IntAsDouble(2^precision);
    return phase;
}

operation U(op : (Qubit) => Unit is Adj + Ctl, power : Int, qubits : Qubit[]) : Unit is Adj + Ctl {
    for _ in 1..power {
        op(qubits[0]);
    }
}

function PrepareOracle(op : (Qubit) => Unit is Adj + Ctl) : ((Int, Qubit[]) => Unit is Adj + Ctl) {
    return U(op, _, _);
}

operation PrepareEigenState(eigenstate : Qubit) : Unit {
    X(eigenstate);
}