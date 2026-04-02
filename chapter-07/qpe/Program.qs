import Std.Arrays.*;
import Std.Convert.*;
import Std.Canon.*;

operation Main() : Unit {
    let phase = ManualEstimation(0, 3);
}

// gateType: 0=Z, 1=S, 2=T
operation ManualEstimation(gateType : Int, precision : Int) : Double {
    use eigenstate = Qubit();
    X(eigenstate);

    use qubits = Qubit[precision];
    ApplyToEachCA(H, qubits);

    for i in 0..precision - 1 {
        let power = 2^((precision - i) - 1);
        Controlled OracleForGate([qubits[i]], (gateType, power, [eigenstate]));
    }

    Adjoint ApplyQFT(qubits);

    let phase = IntAsDouble(MeasureInteger(qubits)) / IntAsDouble(2^precision);
    Reset(eigenstate);
    return phase;
}

// gateType: 0=Z, 1=S, 2=T
operation BuiltinEstimation(gateType : Int, precision : Int) : Double {
    use eigenstate = Qubit();
    X(eigenstate);

    use phaseRegister = Qubit[precision];
    ApplyQPE(OracleForGate(gateType, _, _), [eigenstate], phaseRegister);

    let phase = IntAsDouble(MeasureInteger(phaseRegister)) / IntAsDouble(2^precision);
    Reset(eigenstate);
    return phase;
}

operation OracleForGate(gateType : Int, power : Int, qubits : Qubit[]) : Unit is Adj + Ctl {
    for _ in 1..power {
        if gateType == 1 { S(qubits[0]); }
        elif gateType == 2 { T(qubits[0]); }
        else { Z(qubits[0]); }
    }
}
