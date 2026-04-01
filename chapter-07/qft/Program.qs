import Std.Diagnostics.*;
import Std.Convert.*;
import Std.Arrays.*;
import Std.Math.*;
import Std.Canon.*;

operation Main() : Unit {
    //
    // uncomment the one desired to run
    //
    // FourQubitQFT_BigEndian_Manual(10);
    // QFT_BigEndian_Framework(10);
    // QFT_BigEndian_Manual(10);

    // FourQubitQFT_LittleEndian_Manual();
    // QFT_LittleEndian_Framework();
}

operation FourQubitQFT_BigEndian_Manual(initialValue : Int) : Unit {
    use qubits = Qubit[4];
    SetValue(initialValue, qubits);

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
    DumpMachine();
    ResetAll(qubits);
}

operation QFT_BigEndian_Manual(initialValue : Int) : Unit {
    use qubits = Qubit[BitSizeI(initialValue)];
    let length = Length(qubits);
    SetValue(initialValue, qubits);

    for i in 0..length-1 {
        H(qubits[i]);
        mutable power = 1;
        for j in i+1..length-1 {
            Controlled R1([qubits[j]], (PI() / 2.0^IntAsDouble(power), qubits[i]));
            set power += 1;
        }
    }

    SwapReverseRegister(qubits);

    DumpMachine();
    ResetAll(qubits);
}

operation QFT_BigEndian_Framework(initialValue : Int) : Unit {
    use qubits = Qubit[BitSizeI(initialValue)];
    SetValue(initialValue, qubits);

    // ApplyQFT operates on little-endian, so reverse to treat as big-endian input
    SwapReverseRegister(qubits);
    ApplyQFT(qubits);
    SwapReverseRegister(qubits);

    DumpMachine();
    ResetAll(qubits);
}

operation SetValue(initialValue : Int, qubits : Qubit[]) : Unit is Adj + Ctl {
    let bits = IntAsBoolArray(initialValue, Length(qubits));
    for i in 0..Length(qubits)-1 {
        if bits[i] {
            X(qubits[i]);
        }
    }
}

operation FourQubitQFT_LittleEndian_Manual() : Unit {
    use qubits = Qubit[4];
    SetValue(10, qubits);

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

    DumpMachine();
    ResetAll(qubits);
}

operation QFT_LittleEndian_Framework() : Unit {
    use qubits = Qubit[4];
    SetValue(10, qubits);

    ApplyQFT(qubits);
    SwapReverseRegister(qubits);

    DumpMachine();
    ResetAll(qubits);
}
