import Std.Arrays.*;

operation Main() : Unit {
    for n in [1, 6] {
        let constZero = DeutschJozsaAlgorithm(n, ConstantZero);
        let constOne = DeutschJozsaAlgorithm(n, ConstantOne);
        let balEq = DeutschJozsaAlgorithm(n, BalancedEqual);
        let balNotEq = DeutschJozsaAlgorithm(n, BalancedNotEqual);
        Message($"n={n}");
        Message($"Constant 0. Result: {Format(constZero)}.");
        Message($"Constant 1. Result: {Format(constOne)}.");
        Message($"Balanced. Result: {Format(balEq)}.");
        Message($"Balanced opposite. Result: {Format(balNotEq)}.");
    }
}

function Format(result : Bool) : String {
    return result ? "constant" | "balanced";
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

function ResultIsZero(result : Result) : Bool {
    return result == Zero;
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