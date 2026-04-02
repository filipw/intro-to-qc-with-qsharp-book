import Std.Convert.*;

operation Main() : Unit {
    let result = BellState(false, false, true, true);
}

// basisZ0/basisZ1: true = PauliZ, false = PauliX
operation BellState(init0 : Bool, init1 : Bool, basisZ0 : Bool, basisZ1 : Bool) : Result[] {
    use (control, target) = (Qubit(), Qubit());
    ApplyP(init0 ? PauliX | PauliI, control);
    ApplyP(init1 ? PauliX | PauliI, target);

    H(control);
    CNOT(control, target);

    let r0 = Measure([basisZ0 ? PauliZ | PauliX], [control]);
    let r1 = Measure([basisZ1 ? PauliZ | PauliX], [target]);
    ResetAll([control, target]);
    return [r0, r1];
}
