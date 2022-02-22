namespace MultiQubitGates {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Main() : Unit {
        Message("Library CNOT");
        LibraryCNOT([false, false]); // |00> 
        LibraryCNOT([false, false]); // |01> 
        LibraryCNOT([false, false]); // |10> 
        LibraryCNOT([false, false]); // |11>   

        Message("Manual CNOT");
        ManualCNOT([false, false]); // |00> 
        ManualCNOT([false, false]); // |01> 
        ManualCNOT([false, false]); // |10> 
        ManualCNOT([false, false]); // |11>   

        Message("Library SWAP");
        LibrarySWAP([false, false]); // |00> 
        LibrarySWAP([false, false]); // |01> 
        LibrarySWAP([false, false]); // |10> 
        LibrarySWAP([false, false]); // |11>   

        Message("Manual SWAP");
        ManualSWAP([false, false]); // |00> 
        ManualSWAP([false, false]); // |01> 
        ManualSWAP([false, false]); // |10> 
        ManualSWAP([false, false]); // |11> 

        Message("Library CCNOT");
        LibraryCCNOT([false, false, false]); // |000> 
        LibraryCCNOT([false, false, false]); // |001> 
        LibraryCCNOT([false, false, false]); // |010> 
        LibraryCCNOT([false, false, false]); // |011> 
        LibraryCCNOT([false, false, false]); // |100> 
        LibraryCCNOT([false, false, false]); // |101> 
        LibraryCCNOT([false, false, false]); // |110> 
        LibraryCCNOT([false, false, false]); // |111> 

        Message("Manual CCNOT");
        ManualCCNOT([false, false, false]); // |000> 
        ManualCCNOT([false, false, false]); // |001> 
        ManualCCNOT([false, false, false]); // |010> 
        ManualCCNOT([false, false, false]); // |011> 
        ManualCCNOT([false, false, false]); // |100> 
        ManualCCNOT([false, false, false]); // |101> 
        ManualCCNOT([false, false, false]); // |110> 
        ManualCCNOT([false, false, false]); // |111> 
    }

    operation LibraryCNOT(initState : Bool[]) : Unit {
        use (control, target) = (Qubit(), Qubit());
        ApplyP(initState[0] ? PauliX | PauliI, control);
        ApplyP(initState[1] ? PauliX | PauliI, target);
  
        CNOT(control, target);
        let result = MultiM([control, target]);
        PrintResult(initState, result);
    }

    operation ManualCNOT(initState : Bool[]) : Unit {
        use (control, target) = (Qubit(), Qubit());
        ApplyP(initState[0] ? PauliX | PauliI, control);
        ApplyP(initState[1] ? PauliX | PauliI, target);

		Controlled X([control], target);
        let result = MultiM([control, target]);
        PrintResult(initState, result);
    }

    operation LibrarySWAP(initState : Bool[]) : Unit {
        use (first, second) = (Qubit(), Qubit());
        ApplyP(initState[0] ? PauliX | PauliI, first);
        ApplyP(initState[1] ? PauliX | PauliI, second);

		SWAP(first, second);
        let result = MultiM([first, second]);
        PrintResult(initState, result);
    }

    operation ManualSWAP(initState : Bool[]) : Unit {
        use (first, second) = (Qubit(), Qubit());
        ApplyP(initState[0] ? PauliX | PauliI, first);
        ApplyP(initState[1] ? PauliX | PauliI, second);

        within {
		    CNOT(first, second);
        }
        apply {
		    CNOT(second, first);
        }
        let result = MultiM([first, second]);
        PrintResult(initState, result);
    }

    operation LibraryCCNOT(initState : Bool[]) : Unit {
        use (control1, control2, target) = (Qubit(), Qubit(), Qubit());
        ApplyP(initState[0] ? PauliX | PauliI, control1);
        ApplyP(initState[1] ? PauliX | PauliI, control2);
        ApplyP(initState[2] ? PauliX | PauliI, target);
  
        CCNOT(control1, control2, target);
        let result = MultiM([control1, control2, target]);
        PrintResult(initState, result);
    }

    operation ManualCCNOT(initState : Bool[]) : Unit {
        use (control1, control2, target) = (Qubit(), Qubit(), Qubit());
        ApplyP(initState[0] ? PauliX | PauliI, control1);
        ApplyP(initState[1] ? PauliX | PauliI, control2);
        ApplyP(initState[2] ? PauliX | PauliI, target);
  
        Controlled X([control1, control2], target);
        let result = MultiM([control1, control2, target]);
        PrintResult(initState, result);
    }  

    function PrintResult(initialState : Bool[], measuredState : Result[]) : Unit {
        mutable input = "";
        mutable output = "";
        for i in 0..Length(initialState)-1 {
            set input += (initialState[i] ? "1" | "0");
            set output += (measuredState[i] == One ? "1" | "0");
        }

        Message($"|{input}> ==> |{output}>");
    }
}