operation Main() : Unit {
    Message("Library CNOT");
    LibraryCNOT([false, false]); // |00>
    LibraryCNOT([false, true]); // |01>
    LibraryCNOT([true, false]); // |10>
    LibraryCNOT([true, true]); // |11>

    Message("Manual CNOT");
    ManualCNOT([false, false]); // |00>
    ManualCNOT([false, true]); // |01>
    ManualCNOT([true, false]); // |10>
    ManualCNOT([true, true]); // |11>

    Message("Library SWAP");
    LibrarySWAP([false, false]); // |00>
    LibrarySWAP([false, true]); // |01>
    LibrarySWAP([true, false]); // |10>
    LibrarySWAP([true, true]); // |11>

    Message("Manual SWAP");
    ManualSWAP([false, false]); // |00>
    ManualSWAP([false, true]); // |01>
    ManualSWAP([true, false]); // |10>
    ManualSWAP([true, true]); // |11>

    Message("Library CCNOT");
    LibraryCCNOT([false, false, false]); // |000>
    LibraryCCNOT([false, false, true]); // |001>
    LibraryCCNOT([false, true, false]); // |010>
    LibraryCCNOT([false, true, true]); // |011>
    LibraryCCNOT([true, false, false]); // |100>
    LibraryCCNOT([true, false, true]); // |101>
    LibraryCCNOT([true, true, false]); // |110>
    LibraryCCNOT([true, true, true]); // |111>

    Message("Manual CCNOT");
    ManualCCNOT([false, false, false]); // |000>
    ManualCCNOT([false, false, true]); // |001>
    ManualCCNOT([false, true, false]); // |010>
    ManualCCNOT([false, true, true]); // |011>
    ManualCCNOT([true, false, false]); // |100>
    ManualCCNOT([true, false, true]); // |101>
    ManualCCNOT([true, true, false]); // |110>
    ManualCCNOT([true, true, true]); // |111>
}

operation LibraryCNOT(initState : Bool[]) : Unit {
    use (control, target) = (Qubit(), Qubit());
    ApplyP(initState[0] ? PauliX | PauliI, control);
    ApplyP(initState[1] ? PauliX | PauliI, target);

    CNOT(control, target);
    let result = MeasureEachZ([control, target]);
    ResetAll([control, target]);
    PrintResult(initState, result);
}

operation ManualCNOT(initState : Bool[]) : Unit {
    use (control, target) = (Qubit(), Qubit());
    ApplyP(initState[0] ? PauliX | PauliI, control);
    ApplyP(initState[1] ? PauliX | PauliI, target);
    Controlled X([control], target);
    let result = MeasureEachZ([control, target]);
    ResetAll([control, target]);
    PrintResult(initState, result);
}

operation LibrarySWAP(initState : Bool[]) : Unit {
    use (first, second) = (Qubit(), Qubit());
    ApplyP(initState[0] ? PauliX | PauliI, first);
    ApplyP(initState[1] ? PauliX | PauliI, second);
    SWAP(first, second);
    let result = MeasureEachZ([first, second]);
    ResetAll([first, second]);
    PrintResult(initState, result);
}

operation ManualSWAP(initState : Bool[]) : Unit {
    use (first, second) = (Qubit(), Qubit());
    ApplyP(initState[0] ? PauliX | PauliI, first);
    ApplyP(initState[1] ? PauliX | PauliI, second);
    within {
        CNOT(first, second);
    } apply {
        CNOT(second, first);
    }
    let result = MeasureEachZ([first, second]);
    ResetAll([first, second]);
    PrintResult(initState, result);
}

operation LibraryCCNOT(initState : Bool[]) : Unit {
    use (control1, control2, target) = (Qubit(), Qubit(), Qubit());
    ApplyP(initState[0] ? PauliX | PauliI, control1);
    ApplyP(initState[1] ? PauliX | PauliI, control2);
    ApplyP(initState[2] ? PauliX | PauliI, target);

    CCNOT(control1, control2, target);
    let result = MeasureEachZ([control1, control2, target]);
    ResetAll([control1, control2, target]);
    PrintResult(initState, result);
}

operation ManualCCNOT(initState : Bool[]) : Unit {
    use (control1, control2, target) = (Qubit(), Qubit(), Qubit());
    ApplyP(initState[0] ? PauliX | PauliI, control1);
    ApplyP(initState[1] ? PauliX | PauliI, control2);
    ApplyP(initState[2] ? PauliX | PauliI, target);

    Controlled X([control1, control2], target);
    let result = MeasureEachZ([control1, control2, target]);
    ResetAll([control1, control2, target]);
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