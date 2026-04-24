import Std.Arrays.*;
import Std.Convert.*;
import Std.Canon.*;

operation Main() : Unit {
    let phase = RunManualEstimation(0, 3);
}

// Python-friendly entry points (gateType: 0=Z, 1=S, 2=T)
operation RunManualEstimation(gateType : Int, precision : Int) : Double {
    use eigenstate = Qubit();
    PrepareEigenState(eigenstate);
    mutable phase = 0.0;
    if gateType == 0 {
        set phase = ManualEstimation(eigenstate, PrepareOracle(Z), precision);
    } elif gateType == 1 {
        set phase = ManualEstimation(eigenstate, PrepareOracle(S), precision);
    } else {
        set phase = ManualEstimation(eigenstate, PrepareOracle(T), precision);
    }
    Reset(eigenstate);
    return phase;
}

operation RunBuiltinEstimation(gateType : Int, precision : Int) : Double {
    use eigenstate = Qubit();
    PrepareEigenState(eigenstate);
    mutable phase = 0.0;
    if gateType == 0 {
        set phase = BuiltinEstimation(eigenstate, PrepareOracle(Z), precision);
    } elif gateType == 1 {
        set phase = BuiltinEstimation(eigenstate, PrepareOracle(S), precision);
    } else {
        set phase = BuiltinEstimation(eigenstate, PrepareOracle(T), precision);
    }
    Reset(eigenstate);
    return phase;
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
