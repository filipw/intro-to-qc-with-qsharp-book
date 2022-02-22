namespace Grover {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    @EntryPoint()
    operation Main() : Unit {
        let bitSize = 8;
        for solution in 0..2^bitSize - 1 {
            let oracle = PrepareOracle(solution);
            let result = Grover(bitSize, oracle);
            Message($"Expected to find: {solution}");
            Message($"Found: {result}");
        }
    }

    operation Grover(n : Int, oracle : (Qubit[]) => Unit is Adj) : Int {
        let r = Floor(PI() / 4.0 * Sqrt(IntAsDouble(2 ^ n)));
        use qubits = Qubit[n];

        ApplyToEach(H, qubits);

        // Grover iterations
        for x in 1 .. r {

            // oracle
            oracle(qubits);

            // diffusor
            Diffusion(qubits);
        }

        let register = LittleEndian(qubits);
        let number = MeasureInteger(register);
        return number;
    }

    function PrepareOracle(solution : Int) : ((Qubit[]) => Unit is Adj) {
        return Oracle(solution, _);
    }

    operation Oracle(solution : Int, qubits : Qubit[]) : Unit is Adj {
        let n = Length(qubits);
        within {
            // IntAsBoolArray is little endian so e.g. 4 -> [False, False, True] not [True, False, False]
            let markerBits = IntAsBoolArray(solution, n);
            for i in 0..n-1 {
                if not markerBits[i] {
                    X(qubits[i]);
                }
            }
        } apply {
            Controlled Z(Most(qubits), Tail(qubits));
        }

        // manual circuit for 100 
        // X(qubits[0]);
        // X(qubits[1]);
        
        // Controlled Z(Most(qubits), Tail(qubits));
        
        // X(qubits[0]);
        // X(qubits[1]);

    }

    operation Diffusion(qubits : Qubit[]) : Unit is Adj {
        within {
            ApplyToEachA(H, qubits);
            ApplyToEachA(X, qubits);
        } apply {
            Controlled Z(Most(qubits), Tail(qubits));
        }
    }
}