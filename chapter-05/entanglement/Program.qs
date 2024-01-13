namespace Entanglement {

    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Main() : Unit {
        TestBellState([false, false], [PauliZ, PauliZ]);
        TestBellState([false, true], [PauliZ, PauliZ]);
        TestBellState([true, false], [PauliZ, PauliZ]);
        TestBellState([true, true], [PauliZ, PauliZ]);
        TestBellState([false, false], [PauliZ, PauliX]);
    }

    operation TestBellState(init : Bool[], bases : Pauli[]) : Unit {
        mutable res = [0, 0, 0, 0];

        for run in 1..4096 {
            use (control, target) = (Qubit(), Qubit());
            ApplyP(init[0] ? PauliX | PauliI, control);
            ApplyP(init[1] ? PauliX | PauliI, target);

            H(control);
            CNOT(control, target);
            // PrepareEntangledState([control], [target]);
            
            let c1 = ResultAsBool(Measure([bases[0]], [control]));
            let c2 = ResultAsBool(Measure([bases[1]], [target]));

            if (not c1 and not c2) { set res w/= 0 <- res[0]+1; }
            if (not c1 and c2) { set res w/= 1 <- res[1]+1; }
            if (c1 and not c2) { set res w/= 2 <- res[2]+1; }
            if (c1 and c2) { set res w/= 3 <- res[3]+1; }
        }
        
        let initialState = (init[0] ? "1" | "0") + (init[1] ? "1" | "0");
        Message($"Initial state: |{initialState}>, measurement of control in {bases[0]} and of target in {bases[1]}");
        Message($"|00>: {res[0]}");
        Message($"|01>: {res[1]}");
        Message($"|10>: {res[2]}");
        Message($"|11>: {res[3]}");
    }
}
