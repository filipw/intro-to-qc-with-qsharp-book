import Std.Arrays.*;

operation Main() : Unit {
    let result = RunDeutschJozsa(1, 0);
}

// oracleType: 0=ConstantZero, 1=ConstantOne, 2=BalancedEqual, 3=BalancedNotEqual
operation RunDeutschJozsa(n : Int, oracleType : Int) : Result[] {
    use (x, y) = (Qubit[n], Qubit());
    X(y);
    ApplyToEach(H, x);
    H(y);

    if oracleType == 0 { ConstantZero(x, y); }
    if oracleType == 1 { ConstantOne(x, y); }
    if oracleType == 2 { BalancedEqual(x, y); }
    if oracleType == 3 { BalancedNotEqual(x, y); }

    ApplyToEach(H, x);

    let result = MeasureEachZ(x);
    ResetAll(x + [y]);
    return result;
}

operation ConstantZero(x : Qubit[], y : Qubit) : Unit is Adj {}

operation ConstantOne(x : Qubit[], y : Qubit) : Unit is Adj {
    X(y);
}

operation BalancedEqual(x : Qubit[], y : Qubit) : Unit is Adj {
    for qubit in x {
        CNOT(qubit, y);
    }
}

operation BalancedNotEqual(x : Qubit[], y : Qubit) : Unit is Adj {
    for qubit in x {
        CNOT(qubit, y);
    }
    X(y);
}
