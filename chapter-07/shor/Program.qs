import Std.Math.*;
import Std.Arrays.*;
import Std.Convert.*;
import Std.Diagnostics.*;
import Std.Random.*;
import Std.Arithmetic.*;
import Std.Canon.*; 

@EntryPoint()
operation Main() : Unit {
    // both the number to factor and the coprime are hardcoded for simplicity
    let N = 15; // number to factor
    let a = 13; // coprime

    mutable factors = [];
    mutable attempt = 0;
    repeat {
        set attempt += 1;
        let estimatedPhase = EstimatePhase(a, N);
        let estimatedPeriod = CalculatePeriodFromPhase(estimatedPhase, N);
        set factors = CalculateFactors(a, N, estimatedPeriod);
    } until not IsEmpty(factors) or attempt >= 5;

    for factor in factors {
        Message($"Non trivial factor discovered: {factor}");
    }
}

function CalculateFactors(a : Int, N : Int, r : Int) : Int[] {
    if r == 0 {
        Message("r is 0");
        return [];
    }

    if r % 2 != 0 {
        Message("r is odd");
        return [];
    }

    let aToHalfR = ExpModI(a, r / 2, N);
    if aToHalfR == N - 1 {
        Message($"{a}^({r}/2) = -1 mod {N}");
        return [];
    }

    // period is valid, find factor candidates based on gcd
    let candidates = [
        GreatestCommonDivisorI(aToHalfR + 1, N), // p
        GreatestCommonDivisorI(aToHalfR - 1, N)
    ]; // q

    // filter out trivial factors
    return Filtered(IsNonTrivialFactor(N, _), candidates);
}

function IsNonTrivialFactor(N : Int, i : Int) : Bool {
    return i > 1 and i < N and N % i == 0;
}

operation EstimatePhase(a : Int, N : Int) : Int {
    // size of the registers is determined by bitsize of number to factor
    let numToFactorBitSize = BitSizeI(N);
    if numToFactorBitSize > 8 {
        fail "Maximum supported integer size is 8 bit.";
    }

    // sse twice the precision for phase estimation
    let precisionBits = 2 * numToFactorBitSize;

    Message($"Estimating phase with {precisionBits} bits of precision.");

    // initialize target register to store eigenstate |1⟩
    use targetRegister = Qubit[numToFactorBitSize];
    
    // allocate qubits for the phase register
    use phaseRegister = Qubit[precisionBits];

    // initialize the target register to |1⟩
    X(targetRegister[numToFactorBitSize - 1]);

    // partially apply the oracle so its signature matches (Int, Qubit[]) => Unit is Adj + Ctl
    let oracle = ApplyOrderFindingOracle(a, N, _, _);
    
    // apply QPE using the oracle
    // use the Canon ApplyQPE directly instead of a custom loop
    ApplyQPE(oracle, targetRegister, phaseRegister);

    // measure the phase register
    let phaseResult = MeasureInteger(phaseRegister);

    // reset the target register
    // clean up both registers
    ResetAll(targetRegister);
    ResetAll(phaseRegister);

    Message($"Phase: {IntAsDouble(phaseResult) / IntAsDouble(2^precisionBits)}");
    return phaseResult;
}

operation ApplyOrderFindingOracle(
    generator : Int,
    modulus : Int,
    power : Int,
    target : Qubit[]
) : Unit is Adj + Ctl {
    // the oracle implements |x⟩ ↦ |x⋅a^power mod N⟩
    ModularMultiplyByConstant(
        modulus,
        ExpModI(generator, power, modulus),
        target
    );
}

// reuse the modular arithmetic operations from the reference implementation
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

function CalculatePeriodFromPhase(measurementResult : Int, N : Int) : Int {
    // convert value like 0.75 to 3/4
    let bitsPrecision = 2 * BitSizeI(N);

    // instead of using Fraction type (removed in Q# 1.x), pass numerator and denominator directly
    let numerator = measurementResult;
    let denominator = 2^bitsPrecision;

    // use ContinuedFractionConvergentI with tuple input and decompose the result tuple
    let (_, period) = ContinuedFractionConvergentI((numerator, denominator), N);

    // take absolute value of the period
    let periodAbs = AbsI(period);

    Message($"Estimated value for r is {periodAbs}");
    return periodAbs;
}
