import Std.Diagnostics.*;
import Std.Convert.*;
import Std.Arrays.*;
import Std.Math.*;
import Std.Canon.*;

operation Main() : Unit {
    DumpFourQubitQFT_BigEndian_Manual(10);
}

operation SetValue(initialValue : Int, qubits : Qubit[]) : Unit is Adj + Ctl {
    let bits = IntAsBoolArray(initialValue, Length(qubits));
    for i in 0..Length(qubits)-1 {
        if bits[i] {
            X(qubits[i]);
        }
    }
}

// Big-endian: 4-qubit manual
operation FourQubitQFT_BigEndian_Manual(qubits : Qubit[]) : Unit {
    H(qubits[0]);
    Controlled S([qubits[1]], qubits[0]);
    Controlled T([qubits[2]], qubits[0]);
    Controlled R1([qubits[3]], (PI()/8.0, qubits[0]));

    H(qubits[1]);
    Controlled S([qubits[2]], qubits[1]);
    Controlled T([qubits[3]], qubits[1]);

    H(qubits[2]);
    Controlled S([qubits[3]], qubits[2]);

    H(qubits[3]);
    SWAP(qubits[2], qubits[1]);
    SWAP(qubits[3], qubits[0]);
}

// Big-endian: generalized manual
operation QFT_BigEndian_Manual(qubits : Qubit[]) : Unit {
    let length = Length(qubits);
    for i in 0..length-1 {
        H(qubits[i]);
        mutable power = 1;
        for j in i+1..length-1 {
            Controlled R1([qubits[j]], (PI() / 2.0^IntAsDouble(power), qubits[i]));
            set power += 1;
        }
    }
    SwapReverseRegister(qubits);
}

// Big-endian: framework (ApplyQFT)
operation QFT_BigEndian_Framework(qubits : Qubit[]) : Unit {
    // ApplyQFT operates on little-endian, so reverse to treat as big-endian input
    SwapReverseRegister(qubits);
    ApplyQFT(qubits);
    SwapReverseRegister(qubits);
}

// Little-endian: 4-qubit manual
operation FourQubitQFT_LittleEndian_Manual(qubits : Qubit[]) : Unit {
    H(qubits[3]);
    Controlled S([qubits[2]], qubits[3]);
    Controlled T([qubits[1]], qubits[3]);
    Controlled R1([qubits[0]], (PI()/8.0, qubits[3]));

    H(qubits[2]);
    Controlled S([qubits[1]], qubits[2]);
    Controlled T([qubits[0]], qubits[2]);

    H(qubits[1]);
    Controlled S([qubits[0]], qubits[1]);

    H(qubits[0]);
    SWAP(qubits[1], qubits[2]);
    SWAP(qubits[0], qubits[3]);
}

// Little-endian: framework (ApplyQFT)
operation QFT_LittleEndian_Framework(qubits : Qubit[]) : Unit {
    ApplyQFT(qubits);
    SwapReverseRegister(qubits);
}

// Dump wrappers - each allocates, applies QFT variant, dumps, and resets

operation DumpFourQubitQFT_BigEndian_Manual(value : Int) : Unit {
    use qs = Qubit[4];
    SetValue(value, qs);
    FourQubitQFT_BigEndian_Manual(qs);
    DumpMachine();
    ResetAll(qs);
}

operation DumpQFT_BigEndian_Manual(value : Int, nQubits : Int) : Unit {
    use qs = Qubit[nQubits];
    SetValue(value, qs);
    QFT_BigEndian_Manual(qs);
    DumpMachine();
    ResetAll(qs);
}

operation DumpQFT_BigEndian_Framework(value : Int, nQubits : Int) : Unit {
    use qs = Qubit[nQubits];
    SetValue(value, qs);
    QFT_BigEndian_Framework(qs);
    DumpMachine();
    ResetAll(qs);
}

operation DumpFourQubitQFT_LittleEndian_Manual(value : Int) : Unit {
    use qs = Qubit[4];
    SetValue(value, qs);
    FourQubitQFT_LittleEndian_Manual(qs);
    DumpMachine();
    ResetAll(qs);
}

operation DumpQFT_LittleEndian_Framework(value : Int, nQubits : Int) : Unit {
    use qs = Qubit[nQubits];
    SetValue(value, qs);
    QFT_LittleEndian_Framework(qs);
    DumpMachine();
    ResetAll(qs);
}
