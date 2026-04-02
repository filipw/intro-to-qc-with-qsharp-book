import Std.Math.*;
import Std.Random.*;
import Std.Logical.*;

operation Main() : Unit {
    let result = QuantumStrategy(true, false);
}

operation ClassicalStrategy(inputA : Bool, inputB : Bool) : (Bool, Bool) {
    return (false, false);
}

operation QuantumStrategy(inputA : Bool, inputB : Bool) : (Bool, Bool) {
    use (qubitA, qubitB) = (Qubit(), Qubit());
    X(qubitA);
    X(qubitB);
    H(qubitA);
    CNOT(qubitA, qubitB);

    let shouldAliceMeasureFirst = DrawRandomBool(0.6);
    if shouldAliceMeasureFirst {
        let resultA = MeasurementA(inputA, qubitA);
        let resultB = not MeasurementB(inputB, qubitB);
        return (resultA, resultB);
    } else {
        let resultB = not MeasurementB(inputB, qubitB);
        let resultA = MeasurementA(inputA, qubitA);
        return (resultA, resultB);
    }
}

operation MeasurementA(bit : Bool, q : Qubit) : Bool {
    let result = Measure([bit ? PauliX | PauliZ], [q]);
    Reset(q);
    return result == One;
}

operation MeasurementB(bit : Bool, q : Qubit) : Bool {
    let rotationAngle = bit ? (2.0 * PI() / 8.0) | (-2.0 * PI() / 8.0);
    Ry(rotationAngle, q);
    return MResetZ(q) == One;
}
