namespace Shor {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Characterization;

    @EntryPoint()
    operation Main() : Unit {
        // both the number to factor and the coprime are hardcoded for simplicity
        // let numToFactor = 21;
        // let coprime = 2;
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

        let aToHalfR = a ^ (r / 2);
        if aToHalfR == N - 1 {
            Message($"{a}^({r}/2) = -1 mod {N}");
            return [];
        }

        // period is valid, find factor candidates based on gcd
        let candidates = [
            GreatestCommonDivisorI(aToHalfR + 1, N), // p 
            GreatestCommonDivisorI(aToHalfR - 1, N)]; // q

        // filter out trivial factors
        let filter = IsNonTrivialFactor(N, _);
        return Filtered(filter, candidates);
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

        // init target register to number 1
        use target = Qubit[numToFactorBitSize];
        X(target[numToFactorBitSize-1]);

        let oracle = DiscreteOracle(PrepareOracle(a, N, _, _));
        use source = Qubit[2 * numToFactorBitSize];

        // run quantum phase estimation
        QuantumPhaseEstimation(oracle, target, BigEndian(source));
        let phaseResult = MeasureInteger(LittleEndian(Reversed(source)));

        Message($"Phase: {IntAsDouble(phaseResult) / IntAsDouble(2^(2 * numToFactorBitSize))}");
        ResetAll(target);
        return phaseResult;
    }

    operation PrepareOracle(a : Int, N : Int, pow : Int, source : Qubit[]) 
        : Unit is Adj + Ctl {
        let multiplier = ExpModI(a, pow, N);
        let register = LittleEndian(source);
        MultiplyByModularInteger(multiplier, N, register);
    }

    function CalculatePeriodFromPhase(measurementResult : Int, N : Int) : Int {
        // convert value like 0.75 to 3/4
        let input = Fraction(measurementResult, 2^(2 * BitSizeI(N)));
        let phase = ContinuedFractionConvergentI(input, N);
        Message($"Estimated value for r is {AbsI(phase::Denominator)}");
        return AbsI(phase::Denominator);
    }
}