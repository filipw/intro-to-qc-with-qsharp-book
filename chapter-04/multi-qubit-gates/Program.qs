operation Main() : Unit {
    let result = LibraryCNOT([false, false]);
}

operation LibraryCNOT(initState : Bool[]) : Result[] {
    use (control, target) = (Qubit(), Qubit());
    ApplyP(initState[0] ? PauliX | PauliI, control);
    ApplyP(initState[1] ? PauliX | PauliI, target);

    CNOT(control, target);
    let result = MeasureEachZ([control, target]);
    ResetAll([control, target]);
    return result;
}

operation ManualCNOT(initState : Bool[]) : Result[] {
    use (control, target) = (Qubit(), Qubit());
    ApplyP(initState[0] ? PauliX | PauliI, control);
    ApplyP(initState[1] ? PauliX | PauliI, target);
    Controlled X([control], target);
    let result = MeasureEachZ([control, target]);
    ResetAll([control, target]);
    return result;
}

operation LibrarySWAP(initState : Bool[]) : Result[] {
    use (first, second) = (Qubit(), Qubit());
    ApplyP(initState[0] ? PauliX | PauliI, first);
    ApplyP(initState[1] ? PauliX | PauliI, second);
    SWAP(first, second);
    let result = MeasureEachZ([first, second]);
    ResetAll([first, second]);
    return result;
}

operation ManualSWAP(initState : Bool[]) : Result[] {
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
    return result;
}

operation LibraryCCNOT(initState : Bool[]) : Result[] {
    use (control1, control2, target) = (Qubit(), Qubit(), Qubit());
    ApplyP(initState[0] ? PauliX | PauliI, control1);
    ApplyP(initState[1] ? PauliX | PauliI, control2);
    ApplyP(initState[2] ? PauliX | PauliI, target);

    CCNOT(control1, control2, target);
    let result = MeasureEachZ([control1, control2, target]);
    ResetAll([control1, control2, target]);
    return result;
}

operation ManualCCNOT(initState : Bool[]) : Result[] {
    use (control1, control2, target) = (Qubit(), Qubit(), Qubit());
    ApplyP(initState[0] ? PauliX | PauliI, control1);
    ApplyP(initState[1] ? PauliX | PauliI, control2);
    ApplyP(initState[2] ? PauliX | PauliI, target);

    Controlled X([control1, control2], target);
    let result = MeasureEachZ([control1, control2, target]);
    ResetAll([control1, control2, target]);
    return result;
}
