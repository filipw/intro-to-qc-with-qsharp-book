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