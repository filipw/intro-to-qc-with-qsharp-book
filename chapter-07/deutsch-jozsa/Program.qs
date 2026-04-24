import Std.Arrays.*;

operation Main() : Unit {
    let result = RunDeutschJozsa(1, 0);
}

// oracleType: 0=ConstantZero, 1=ConstantOne, 2=BalancedEqual, 3=BalancedNotEqual
operation RunDeutschJozsa(n : Int, oracleType : Int) : Bool {
    if oracleType == 0 { return DeutschJozsaAlgorithm(n, ConstantZero); }
    if oracleType == 1 { return DeutschJozsaAlgorithm(n, ConstantOne); }
    if oracleType == 2 { return DeutschJozsaAlgorithm(n, BalancedEqual); }
    return DeutschJozsaAlgorithm(n, BalancedNotEqual);
}

operation DeutschJozsaAlgorithm(n : Int, oracle : ((Qubit[], Qubit) => Unit)) : Bool {
    use (x, y) = (Qubit[n], Qubit());
    X(y);
    ApplyToEach(H, x);
    H(y);

    oracle(x, y);

    ApplyToEach(H, x);

    let allZeroes = All(result -> result == Zero, MeasureEachZ(x));
    ResetAll(x + [y]);
    return allZeroes;
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
