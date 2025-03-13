import Std.Diagnostics.*;
import Std.Arrays.*;
import Std.Convert.*;

operation Main() : Unit {
    use eigenstate = Qubit();

    TestPhaseEstimation(
        PrepareOracle(Z),
        PrepareEigenState(eigenstate),
        0.5
    );
    TestPhaseEstimation(
        PrepareOracle(S),
        PrepareEigenState(eigenstate),
        0.25
    );
    TestPhaseEstimation(
        PrepareOracle(T),
        PrepareEigenState(eigenstate),
        0.125
    );
}

operation TestPhaseEstimation(oracle : (Int, Qubit[]) => Unit is Adj + Ctl, eigenstate : Qubit, expectedPhase : Double) : Unit {
    let manualPhase = ManualEstimation(eigenstate, oracle, 3);
    Message($"Expected: {expectedPhase}");

    // note: there is no built in phase estimation at the moment in the new QDK 1.x
    //let libPhase = BuiltinEstimation(eigenstate, oracle, 3);
    //Message($"Library: {libPhase}");
    Message($"Manual: {manualPhase}");
    Message("");
    Reset(eigenstate);
}

// note: there is no built in phase estimation at the moment in the new QDK 1.x
// operation BuiltinEstimation(eigenstate : Qubit, oracle : ((Int, Qubit[]) => Unit is Adj + Ctl), precision : Int) : Double {
//     use qubits = Qubit[precision];
//     QuantumPhaseEstimation(DiscreteOracle(oracle), [eigenstate], BigEndian(qubits));
//     let phase = IntAsDouble(MeasureInteger(LittleEndian(Reversed(qubits)))) / IntAsDouble(2^precision);
//     return phase;
// }

operation ManualEstimation(eigenstate : Qubit, oracle : ((Int, Qubit[]) => Unit is Adj + Ctl), precision : Int) : Double {
    use qubits = Qubit[precision];
    ApplyToEach(H, qubits);

    for i in 0..precision - 1 {
        Controlled oracle([qubits[i]], (2^i, [eigenstate]));
    }

    Adjoint QFTLE(qubits);
    // alternative:
    //Adjoint ApproximateQFT(Length(qubits), Reversed(qubits));

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

operation PrepareEigenState(eigenstate : Qubit) : Qubit {
    X(eigenstate);
    return eigenstate;
}

operation QFTLE(qs : Qubit[]) : Unit is Adj + Ctl {
    // reversal needed since we want to use little endian order
    ApproximateQFT(Length(qs), Reversed(qs));
}

// original QDK QFT implmentation for big-endian
operation ApproximateQFT(a : Int, qs : Qubit[]) : Unit is Adj + Ctl {
    let nQubits = Length(qs);
    Fact(nQubits > 0, "`Length(qs)` must be least 1");
    Fact(a > 0 and a <= nQubits, "`a` must be positive and less than `Length(qs)`");

    for i in 0..nQubits - 1 {
        for j in 0..i - 1 {
            if i - j < a {
                Controlled R1Frac([qs[i]], (1, i - j, (qs)[j]));
            }
        }

        H(qs[i]);
    }

    SwapReverseRegister(qs);
}