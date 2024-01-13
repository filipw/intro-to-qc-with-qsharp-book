namespace Bell {

    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Main() : Unit {
        let pAB = RunBell(Uab);
        Message($"P(a+,b+) = {pAB}");

        let pBC = RunBell(Ubc);
        Message($"P(b+,c+) = {pBC}");

        let pAC = RunBell(Uac);
        Message($"P(a+,c+) = {pAC}");

        let bellInequalityResult = pAB + pBC >= pAC;
        Message($"Bell's inequality satisfied? {bellInequalityResult}");

        let eA1B1 = RunCHSH(Ua1b1);
        Message($"E(a1,b1) = {eA1B1}");

        let eA1B2 = RunCHSH(Ua1b2);
        Message($"E(a1,b2) = {eA1B2}");

        let eA2B1 = RunCHSH(Ua2b1);
        Message($"E(a2,b1) = {eA2B1}");

        let eA2B2 = RunCHSH(Ua2b2);
        Message($"E(a2,b2) = {eA2B2}");

        let chshInequalityResult = AbsD(eA1B1 + eA1B2) + AbsD(eA2B1 - eA2B2) <= 2.0;
        Message($"CHSH inequality satisfied? {chshInequalityResult}");
    }

    operation RunBell(op: ((Qubit, Qubit) => Unit)) : Double {
        mutable res = [0, 0, 0, 0];
        
        let runs = 4096;
        for i in 0 .. runs {
            use (q1, q2) = (Qubit(), Qubit());
            PrepareBellState(q1, q2);
            op(q1, q2);
            let (r1, r2) = (MResetX(q1), MResetX(q2));

            if (r1 == Zero and r2 == Zero) { set res w/= 0 <- res[0]+1; }
            if (r1 == Zero and r2 == One) { set res w/= 1 <- res[1]+1; }
            if (r1 == One and r2 == Zero) { set res w/= 2 <- res[2]+1; }
            if (r1 == One and r2 == One) { set res w/= 3 <- res[3]+1; }
        }
        let p = IntAsDouble(res[0]) / IntAsDouble(runs);
        return p;
    }

    operation RunCHSH(op: ((Qubit, Qubit) => Unit)) : Double {
        mutable res = [0, 0, 0, 0];
        
        let runs = 4096;
        for i in 0 .. runs {
            use (q1, q2) = (Qubit(), Qubit());
            PrepareBellState(q1, q2);
            op(q1, q2);
            let (r1, r2) = (MResetX(q1), MResetX(q2));

            if (r1 == Zero and r2 == Zero) { set res w/= 0 <- res[0]+1; }
            if (r1 == Zero and r2 == One) { set res w/= 1 <- res[1]+1; }
            if (r1 == One and r2 == Zero) { set res w/= 2 <- res[2]+1; }
            if (r1 == One and r2 == One) { set res w/= 3 <- res[3]+1; }
        }

        let p = IntAsDouble(res[0] + res[3] - res[2] - res[1]) / IntAsDouble(runs);
        return p;
    }

    operation PrepareBellState(q1 : Qubit, q2: Qubit) : Unit {
        X(q1);
        X(q2);
        H(q1);
        CNOT(q1, q2);
    }

    // Bell
    operation Uab(q1 : Qubit, q2: Qubit) : Unit {
        R1(PI() / 3.0, q2);
    }

    operation Uac(q1 : Qubit, q2: Qubit)  : Unit {
        R1(2.0 * PI() / 3.0, q2);
    }

    operation Ubc(q1 : Qubit, q2: Qubit)  : Unit {
        R1(PI() / 3.0, q1);
        R1(2.0 * PI() / 3.0, q2);
    }

    // CHSH
    operation Ua1b1(q1 : Qubit, q2: Qubit) : Unit {
        R1(PI() / 4.0, q1);
        R1(2.0 * PI() / 4.0, q2);
    }

    operation Ua1b2(q1 : Qubit, q2: Qubit)  : Unit {
        R1(PI() / 4.0, q1);
    }

    operation Ua2b1(q1 : Qubit, q2: Qubit)  : Unit {
        R1(3.0 * PI() / 4.0, q1);
        R1(2.0 * PI() / 4.0, q2);
    }

    operation Ua2b2(q1 : Qubit, q2: Qubit)  : Unit {
        R1(3.0 * PI() / 4.0, q1);
    }
}