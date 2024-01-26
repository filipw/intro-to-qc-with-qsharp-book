# Introduction to Quantum Computing with Q# and QDK

Code samples from the [Introduction to Quantum Computing with Q# and QDK](https://link.springer.com/book/10.1007/978-3-030-99379-5) book, published by Springer Nature on 7 May 2022.

## About the book

This book introduces the fundamentals of the theory of quantum computing, illustrated with code samples written in Q#, a quantum-specific programming language, and its related Quantum Development Kit. Quantum computing (QC) is a multidisciplinary field that sits at the intersection of quantum physics, quantum information theory, computer science and mathematics, and which may revolutionize the world of computing and software engineering. 

The book begins by covering historical aspects of quantum theory and quantum computing, as well as offers a gentle, algebra-based, introduction to quantum mechanics, specifically focusing on concepts essential for the field of quantum programming. Quantum state description, state evolution, quantum measurement and the Bell’s theorem are among the topics covered. The readers also get a tour of the features of Q# and familiarize themselves with the QDK.  

Next, the core QC topics are discussed, complete with the necessary mathematical formalism. This includes the notions of qubit, quantum gates and quantum circuits. In addition to that, the book provides a detailed treatment of a series of important concepts from quantum information theory, in particular entanglement and the no-cloning theorem, followed by discussion about quantum key distribution and its various protocols. Finally, the canon of most important QC algorithms and algorithmic techniques is covered in-depth - from the Deutsch-Jozsa algorithm, through Grover’s search, to Quantum Fourier Transform, quantum phase estimation and Shor’s algorithm.  

The book is an accessible introduction into the vibrant and fascinating field of quantum computing, offering a blend of academic diligence with pragmatism that is so central to software development world. All of the discussed theoretical aspects of QC are accompanied by runnable code examples, providing the reader with two different angles - mathematical and programmatic - of looking at the same problem space. 

## Compatibility notes

The [main](https://github.com/filipw/intro-to-qc-with-qsharp-book) branch in this repository contains the sample code that matches the content of the book *as it was published*. The code was written using the version [0.21.2112180703](https://learn.microsoft.com/en-us/azure/quantum/release-notes-2021#qdk-version-0212112180703) of the QDK and the Q# language, which was released on 14th December 2021. The code should also work fine with all the newer versions of QDK lower than 1.0 (the last pre-1.0 release was [0.28.302812](https://learn.microsoft.com/en-us/azure/quantum/release-notes-2023#qdk-version-028302812) on 15 September 2023).

[QDK 1.0](https://devblogs.microsoft.com/qsharp/announcing-v1-0-of-the-azure-quantum-development-kit/) was released on 12 January 2024 and contains numerous breaking changes and feature gaps in the libraries and in the language itself. The code samples ported to that release can be found on the [qdk-1.0](https://github.com/filipw/intro-to-qc-with-qsharp-book/tree/qdk-1.0) branch. 

You can also use the table below to navigate the samples, and switch between the versions in the book (QDK 0.2x) and QDK 1.0.

## List of examples

|Name|Chapter|Description|QDK 0.2x|QDK 1.0|
|---|:---:|---|---|---|
|basic|3|Basic Q# language examples|[link](../../tree/main/chapter-03/basic)|[link](../../tree/qdk-1.0/chapter-03/basic)
|basic-qubits|4|Basic qubit examples|[link](../../tree/main/chapter-04/basic-qubits)|[link](../../tree/qdk-1.0/chapter-04/basic-qubits)
|superposition|4|Superposition examples|[link](../../tree/main/chapter-04/superposition)|[link](../../tree/qdk-1.0/chapter-04/superposition)
|single qubit gates|4|Single qubit gates examples|[link](../../tree/main/chapter-04/single-qubit-gates)|[link](../../tree/qdk-1.0/chapter-04/single-qubit-gates)
|multi qubit gates|4|Multi qubit gates examples|[link](../../tree/main/chapter-04/multi-qubit-gates)|[link](../../tree/qdk-1.0/chapter-04/multi-qubit-gates)
|entanglement|5|Basic Bell states examples|[link](../../tree/main/chapter-05/entanglement)|[link](../../tree/qdk-1.0/chapter-05/entanglement)
|bell|5|Bell's inequality examples|[link](../../tree/main/chapter-05/bell)|[link](../../tree/qdk-1.0/chapter-05/bell)
|chsh|5|CHSH game example|[link](../../tree/main/chapter-05/chsh)|[link](../../tree/qdk-1.0/chapter-05/chsh)
|ghz|5|GHZ game example|[link](../../tree/main/chapter-05/ghz)|[link](../../tree/qdk-1.0/chapter-05/ghz)
|teleportation|5|Teleportation example|[link](../../tree/main/chapter-05/teleportation)|[link](../../tree/qdk-1.0/chapter-05/teleportation)
|entanglement swapping|5|Entanglement swapping example|[link](../../tree/main/chapter-05/entanglement-swapping)|[link](../../tree/qdk-1.0/chapter-05/entanglement-swapping)
|superdense|5|Superdense coding example|[link](../../tree/main/chapter-05/superdense)|[link](../../tree/qdk-1.0/chapter-05/superdense)
|bb84|6|BB84 protocol example|[link](../../tree/main/chapter-06/bb84)|[link](../../tree/qdk-1.0/chapter-06/bb84)
|b92|6|B92 protocol example|[link](../../tree/main/chapter-06/b92)|[link](../../tree/qdk-1.0/chapter-06/b92)
|eprqkd|6|EPR QDK protocol example|[link](../../tree/main/chapter-06/eprqkd)|[link](../../tree/qdk-1.0/chapter-06/eprqkd)
|deutsch-jozsa|7|Deutsch-Jozsa algorithm|[link](../../tree/main/chapter-07/deutsch-jozsa)|[link](../../tree/qdk-1.0/chapter-07/deutsch-jozsa)
|bernstein-vazirani|7|Bernstein-Vazirani algorithm|[link](../../tree/main/chapter-07/bernstein-vazirani)|[link](../../tree/qdk-1.0/chapter-07/bernstein-vazirani)
|grover|7|Grover algorithm|[link](../../tree/main/chapter-07/grover)|[link](../../tree/qdk-1.0/chapter-07/grover)
|qft|7|Quantum Fourier Transform example|[link](../../tree/main/chapter-07/qft)|n/a
|qpe|7|Quantum phase estimation example|[link](../../tree/main/chapter-07/qpe)|[link](../../tree/qdk-1.0/chapter-07/qpe)
|shor|7|Shor's algorithm|[link](../../tree/main/chapter-07/shor)|n/a