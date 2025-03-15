# Introduction to Quantum Computing with Q# and QDK

Code samples from the [Introduction to Quantum Computing with Q# and QDK](https://link.springer.com/book/10.1007/978-3-030-99379-5) book, published by Springer Nature on 7 May 2022.

## About the book

This book introduces the fundamentals of the theory of quantum computing, illustrated with code samples written in Q#, a quantum-specific programming language, and its related Quantum Development Kit. Quantum computing (QC) is a multidisciplinary field that sits at the intersection of quantum physics, quantum information theory, computer science and mathematics, and which may revolutionize the world of computing and software engineering. 

The book begins by covering historical aspects of quantum theory and quantum computing, as well as offers a gentle, algebra-based, introduction to quantum mechanics, specifically focusing on concepts essential for the field of quantum programming. Quantum state description, state evolution, quantum measurement and the Bell’s theorem are among the topics covered. The readers also get a tour of the features of Q# and familiarize themselves with the QDK.  

Next, the core QC topics are discussed, complete with the necessary mathematical formalism. This includes the notions of qubit, quantum gates and quantum circuits. In addition to that, the book provides a detailed treatment of a series of important concepts from quantum information theory, in particular entanglement and the no-cloning theorem, followed by discussion about quantum key distribution and its various protocols. Finally, the canon of most important QC algorithms and algorithmic techniques is covered in-depth - from the Deutsch-Jozsa algorithm, through Grover’s search, to Quantum Fourier Transform, quantum phase estimation and Shor’s algorithm.  

The book is an accessible introduction into the vibrant and fascinating field of quantum computing, offering a blend of academic diligence with pragmatism that is so central to software development world. All of the discussed theoretical aspects of QC are accompanied by runnable code examples, providing the reader with two different angles - mathematical and programmatic - of looking at the same problem space. 

## Compatibility notes

The [main](https://github.com/filipw/intro-to-qc-with-qsharp-book) branch in this repository contains the sample code that matches the content of the book *as it was published*. The code was written using the version [0.21.2112180703](https://learn.microsoft.com/en-us/azure/quantum/release-notes-2021#qdk-version-0212112180703) of the QDK and the Q# language, which was released on 14th December 2021. The code should also work fine with all the newer versions of QDK lower than 1.0 (the last pre-1.0 release was [0.28.302812](https://learn.microsoft.com/en-us/azure/quantum/release-notes-2023#qdk-version-028302812) on 15 September 2023).

[QDK 1.0](https://devblogs.microsoft.com/qsharp/announcing-v1-0-of-the-azure-quantum-development-kit/) was released on 12 January 2024 and contains numerous breaking changes and feature gaps in the libraries and in the language itself. The code samples ported to that release can be found on the [qdk-1.x](https://github.com/filipw/intro-to-qc-with-qsharp-book/tree/qdk-1.x) branch.

You can also use the table below to navigate the samples, and switch between the versions in the book (QDK 0.2x) and QDK 1.x.

## List of examples

|Name|Chapter|Description|QDK 0.2x|QDK 1.x|
|---|:---:|---|---|---|
|basic|3|Basic Q# language examples|[link](../../tree/main/chapter-03/basic)|[link](../../tree/qdk-1.x/chapter-03/basic)
|basic-qubits|4|Basic qubit examples|[link](../../tree/main/chapter-04/basic-qubits)|[link](../../tree/qdk-1.x/chapter-04/basic-qubits)
|superposition|4|Superposition examples|[link](../../tree/main/chapter-04/superposition)|[link](../../tree/qdk-1.x/chapter-04/superposition)
|single qubit gates|4|Single qubit gates examples|[link](../../tree/main/chapter-04/single-qubit-gates)|[link](../../tree/qdk-1.x/chapter-04/single-qubit-gates)
|multi qubit gates|4|Multi qubit gates examples|[link](../../tree/main/chapter-04/multi-qubit-gates)|[link](../../tree/qdk-1.x/chapter-04/multi-qubit-gates)
|entanglement|5|Basic Bell states examples|[link](../../tree/main/chapter-05/entanglement)|[link](../../tree/qdk-1.x/chapter-05/entanglement)
|bell|5|Bell's inequality examples|[link](../../tree/main/chapter-05/bell)|[link](../../tree/qdk-1.x/chapter-05/bell)
|chsh|5|CHSH game example|[link](../../tree/main/chapter-05/chsh)|[link](../../tree/qdk-1.x/chapter-05/chsh)
|ghz|5|GHZ game example|[link](../../tree/main/chapter-05/ghz)|[link](../../tree/qdk-1.x/chapter-05/ghz)
|teleportation|5|Teleportation example|[link](../../tree/main/chapter-05/teleportation)|[link](../../tree/qdk-1.x/chapter-05/teleportation)
|entanglement swapping|5|Entanglement swapping example|[link](../../tree/main/chapter-05/entanglement-swapping)|[link](../../tree/qdk-1.x/chapter-05/entanglement-swapping)
|superdense|5|Superdense coding example|[link](../../tree/main/chapter-05/superdense)|[link](../../tree/qdk-1.x/chapter-05/superdense)
|bb84|6|BB84 protocol example|[link](../../tree/main/chapter-06/bb84)|[link](../../tree/qdk-1.x/chapter-06/bb84)
|b92|6|B92 protocol example|[link](../../tree/main/chapter-06/b92)|[link](../../tree/qdk-1.x/chapter-06/b92)
|eprqkd|6|EPR QDK protocol example|[link](../../tree/main/chapter-06/eprqkd)|[link](../../tree/qdk-1.x/chapter-06/eprqkd)
|deutsch-jozsa|7|Deutsch-Jozsa algorithm|[link](../../tree/main/chapter-07/deutsch-jozsa)|[link](../../tree/qdk-1.x/chapter-07/deutsch-jozsa)
|bernstein-vazirani|7|Bernstein-Vazirani algorithm|[link](../../tree/main/chapter-07/bernstein-vazirani)|[link](../../tree/qdk-1.x/chapter-07/bernstein-vazirani)
|grover|7|Grover algorithm|[link](../../tree/main/chapter-07/grover)|[link](../../tree/qdk-1.x/chapter-07/grover)
|qft|7|Quantum Fourier Transform example|[link](../../tree/main/chapter-07/qft)|n/a
|qpe|7|Quantum phase estimation example|[link](../../tree/main/chapter-07/qpe)|[link](../../tree/qdk-1.x/chapter-07/qpe)
|shor|7|Shor's algorithm|[link](../../tree/main/chapter-07/shor)|[link](../../tree/qdk-1.x/chapter-07/shor)

# QDK 1.x migration notes

Below is the list of breaking changes that occur in QDK 1.x, compared to QDK 0.2x. Note that this is not a comprehensive list, but one that focuses on the content and the code used in this book. It effectively summarizes that changes that have been applied between the `main` and `qdk-1.x` branches.

The grouping into chapters helps identify when a given braking change can be **first** encountered in the book. However, once it has been mentioned, it is not repeated again.

## General

### Mandatory qubit release

The explicit release of qubits is now mandatory (it used to happen implicitly).
Use `Reset`, `ResetAll` or measurement with a built-in reset (for example `MResetZ` instead of `M`).

### Namespaces

Q# now has implicit namespaces (file is a de facto namespace) so the code no longer must be wrapped in a namespace explicitly. Reusable functions and operations must be explicitly exported if they are needed in another file.

Additionally, all `Microsoft.*` namespaces got renamed to `Std.*`. Namespaces are now imported using the `import` keyword, instead of `open`. Individual callabales can be explicitly imported, or the entire namespace can be imported using `import *` syntax.

Finally, all the intrinsic operations are implicitly imported, so there is no need to import them explicitly.

For example:

```qsharp
namespace Microsoft.Quantum.Samples {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;
}
```

Can be simplified to:

```qsharp
import Std.Arrays.*;
import Std.Diagnostics.*;
import Std.Math.*;
```

### Explicit return is not necessary anymore

This is not a breaking change, but an alternative new syntax. A return statement on the last line of a function or operation may be omitted for brevity. In such cases the trailing semicolon is also omitted. For example:

```qsharp
function Hello() : String {
    return "Hello, world!";
}
```

Can be simplified to:

```qsharp
function Hello() : String {
    "Hello, world!"
}
```

### Lambdas

When the book was written, the QDK did not support lambdas yet. Those are now supported. As a result, helper functions are not needed where lambdas can be used. For example:

```qsharp
let allZeroes = All(ResultIsZero, MeasureEachZ(x));

function ResultIsZero(result : Result) : Bool {
    return result == Zero;
}
```

Can become:

```qsharp
let allZeroes = All(result -> result == Zero, MeasureEachZ(x));
```

### Tuple decomposition now supported

Q# 1.x supports direct tuple decomposition, eliminating the need for accessing tuple elements with the `::Item1`, `::Item2`, etc. syntax.

```qsharp
let tuple = SomeFunction();
let firstItem = tuple::Item1;
let secondItem = tuple::Item2;
```

Can be simplified to:

```qsharp
let (firstItem, secondItem) = SomeFunction();
```

## Chapter 3

### `@Attribute()` missing

This cannot be ported as user-defined attributes are no longer supported in Q#.

### `BoolAsString` missing

Can be replaced with simple string interpolation
i.e. `BoolAsString(flag)` -> `$“{flag}”` 

### `DoubleAsInt` missing

Can be replaced with `Truncate` function from the `Microsoft.Quantum.Math` namespace.

## Chapter 4

### `MultiM` missing

operation `MultiM` is missing.
However, internally it was really just a loop of measurements.

Can be replaced with `MeasureEachZ` or a manual measurement loop.

### `LittleEndian` and `BigEndian` types missing

Wherever needed, we can now just pass qubit array in little-endian or big-endian format instead - ideally with the ordering explained in comments when necessary.

### MeasureInteger

`MeasureInteger` takes a qubit array now, instead of a `LittleEndian` register
It is newly in the `Microsoft.Quantum.Measurement` namespace.

### `OperationPow` is missing

This can be replaced with:

```qsharp
function OperationPow<'T> (op : ('T => Unit), power : Int) : ('T => Unit) {
    return ApplyOperationRepeatedly(op, power, _);
}

internal operation ApplyOperationRepeatedly<'T> (op : ('T => Unit), power : Int, target : 'T)
: Unit {
    for idxApplication in 0 .. power - 1 {
        op(target);
    }
}
```

or simply by calling the operation the required (N) amount of times.

## Chapter 5

### `IsResultZero` and `IsResultOne` are missing

These can be replaced with simple checks: `result == Zero` or `result == One`.

### `DoubleAsStringWithFormat` missing

Replaced with `DoubleAsStringWithPrecision(number, precision)`.

### `PrepareEntangledState` is missing

This was just a shorthand for creating entanglement using H + CNOT - can be added manually wherever needed.

## Chapter 6

### `EqualA`, `EqualB` missing

This is not necessary as most types are now comparable to each other.

For example: `if (EqualA(EqualB, aliceBits, bobBits))`
can become `if aliceBits == bobBits`

### `IntAsString` missing

Not needed, can be solved with just interpolation or concatenation to a string.

For example simple string interpolation
i.e. `IntAsString(number)` -> `$“{number}”`

## Chapter 7

### `CControlledCA` is missing

Can be re-added by hand. Here is the polyfill:

```qsharp
function CControlledCA<'T> (op : ('T => Unit is Ctl + Adj)) : ((Bool, 'T) => Unit is Ctl + Adj) {
    return ApplyIfCA(_, op, _);
}

operation ApplyIfCA<'T> (bit : Bool, op : ('T => Unit is Ctl + Adj), target : 'T) : Unit is Ctl + Adj {
    if (bit) {
        op(target);
    }
}
```

### `QuantumPhaseEstimation` missing

Phase estimation has to be done manually. See the sample code in this repo.

### `QFTLE` and `QFT` missing

There is now `ApplyQFT` but it behaves differently (no swap) and is little endian by default.
It’s very easy to polyfill though:

```qsharp
operation QFTLE(qs : Qubit[]) : Unit is Adj + Ctl {
    // reversal needed since we want to use little endian order
    ApproximateQFT(Length(qs), Reversed(qs));
}

// original QDK QFT implementation for big-endian
operation ApproximateQFT (a : Int, qs : Qubit[]) : Unit is Adj + Ctl {
     let nQubits = Length(qs);
     Fact(nQubits > 0, "`Length(qs)` must be least 1");
     Fact(a > 0 and a <= nQubits, "`a` must be positive and less than `Length(qs)`");
     for i in 0 .. nQubits - 1 {
         for j in 0 .. i - 1 {
             if i - j < a {
                 Controlled R1Frac([qs[i]], (1, i - j, (qs)[j]));
             }
         }
         H(qs[i]);
     }
     SwapReverseRegister(qs);
}
```

### `Fraction` type missing

The `Fraction` type has been removed in QDK 1.x. Calculations with fractions can now be handled using tuples directly. For example:

```qsharp
let input = Fraction(numerator, denominator);
let result = ContinuedFractionConvergentI(input, modulus);
let period = AbsI(result::Denominator);
```

Can be replaced with:

```qsharp
// New code
let (_, period) = ContinuedFractionConvergentI((numerator, denominator), modulus);
let periodAbs = AbsI(period);
```

### `DiscreteOracle` type missing

The `DiscreteOracle` type is no longer available in QDK 1.x. Instead, functions and operations that previously used it should be refactored to accept and use controlled operations directly.

```qsharp
let oracle = DiscreteOracle(PrepareOracle(a, N, _, _));
QuantumPhaseEstimation(oracle, target, BigEndian(source));
```

Can be replaced with a direct implementation of phase estimation that takes the appropriate operations as parameters.
