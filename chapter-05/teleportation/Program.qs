namespace teleportation {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Random;

    @EntryPoint()
    operation Start() : Unit {
        let runs = 4096;
        mutable successCount = 0;

        for i in 1..runs {
            use (message, resource, target) = (Qubit(), Qubit(), Qubit());

            PrepareState(message);

            Teleport(message, resource, target);
            Adjoint PrepareState(target);
            set successCount += M(target) == Zero ? 1 | 0;
            ResetAll([message, resource, target]);
        }

        Message($"Success rate: {100. * IntAsDouble(successCount) / IntAsDouble(runs)}");
    }

    operation Teleport(message : Qubit, resource : Qubit, target : Qubit) : Unit {
        // create entanglement between resource and target
        H(resource);
        CNOT(resource, target);

        // reverse Bell circuit on message and resource
        CNOT(message, resource);
        H(message);

        // mesaure message and resource
        let messageResult = M(message) == One;
        let resourceResult = M(resource) == One;

        // and decode state
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
}