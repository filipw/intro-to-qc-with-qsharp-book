import Std.Math.*;

operation Main() : Unit {
    let result = RunTeleportation();
}

// Returns Zero if teleportation succeeded
operation RunTeleportation() : Result {
    use (message, resource, target) = (Qubit(), Qubit(), Qubit());
    PrepareState(message);
    Teleport(message, resource, target);
    Adjoint PrepareState(target);
    let result = M(target);
    ResetAll([message, resource, target]);
    return result;
}

operation Teleport(message : Qubit, resource : Qubit, target : Qubit) : Unit {
    H(resource);
    CNOT(resource, target);

    CNOT(message, resource);
    H(message);

    let messageResult = M(message) == One;
    let resourceResult = M(resource) == One;

    DecodeTeleportedState(messageResult, resourceResult, target);
}

operation PrepareState(q : Qubit) : Unit is Adj + Ctl {
    Rx(1. * PI() / 2., q);
    Ry(2. * PI() / 3., q);
    Rz(3. * PI() / 4., q);
}

operation DecodeTeleportedState(messageResult : Bool, resourceResult : Bool, target : Qubit) : Unit {
    if not messageResult and not resourceResult {
        I(target);
    }
    if not messageResult and resourceResult {
        X(target);
    }
    if messageResult and not resourceResult {
        Z(target);
    }
    if messageResult and resourceResult {
        Z(target);
        X(target);
    }
}
