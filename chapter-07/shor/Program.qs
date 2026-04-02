import Std.Math.*;
import Std.Arrays.*;
import Std.Convert.*;
import Std.Canon.*;
import Std.Arithmetic.*;

operation Main() : Unit {
    let phase = EstimatePhase(13, 15);
}

operation EstimatePhase(a : Int, N : Int) : Int {
    let numToFactorBitSize = BitSizeI(N);
    if numToFactorBitSize > 8 {
        fail "Maximum supported integer size is 8 bit.";
    }

    let precisionBits = 2 * numToFactorBitSize;

    use targetRegister = Qubit[numToFactorBitSize];
    use phaseRegister = Qubit[precisionBits];

    // initialize the target register to |1⟩
    X(targetRegister[numToFactorBitSize - 1]);

    let oracle = ApplyOrderFindingOracle(a, N, _, _);
    ApplyQPE(oracle, targetRegister, phaseRegister);

    let phaseResult = MeasureInteger(phaseRegister);
    ResetAll(targetRegister);
    return phaseResult;
}

operation ApplyOrderFindingOracle(
    generator : Int,
    modulus : Int,
    power : Int,
    target : Qubit[]
) : Unit is Adj + Ctl {
    ModularMultiplyByConstant(
        modulus,
        ExpModI(generator, power, modulus),
        target
    );
}

operation ModularMultiplyByConstant(modulus : Int, c : Int, y : Qubit[]) : Unit is Adj + Ctl {
    use qs = Qubit[Length(y)];
    for idx in IndexRange(y) {
        let shiftedC = (c <<< idx) % modulus;
        Controlled ModularAddConstant(
            [y[idx]],
            (modulus, shiftedC, qs)
        );
    }
    for idx in IndexRange(y) {
        SWAP(y[idx], qs[idx]);
    }
    let invC = InverseModI(c, modulus);
    for idx in IndexRange(y) {
        let shiftedC = (invC <<< idx) % modulus;
        Controlled ModularAddConstant(
            [y[idx]],
            (modulus, modulus - shiftedC, qs)
        );
    }
}

operation ModularAddConstant(modulus : Int, c : Int, y : Qubit[]) : Unit is Adj + Ctl {
    body (...) {
        Controlled ModularAddConstant([], (modulus, c, y));
    }
    controlled (ctrls, ...) {
        if Length(ctrls) >= 2 {
            use control = Qubit();
            within {
                Controlled X(ctrls, control);
            } apply {
                Controlled ModularAddConstant([control], (modulus, c, y));
            }
        } else {
            use carry = Qubit();
            Controlled IncByI(ctrls, (c, y + [carry]));
            Controlled Adjoint IncByI(ctrls, (modulus, y + [carry]));
            Controlled IncByI([carry], (modulus, y));
            Controlled ApplyIfLessOrEqualL(ctrls, (X, IntAsBigInt(c), y, carry));
        }
    }
}
