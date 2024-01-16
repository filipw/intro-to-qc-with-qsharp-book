namespace Basic {

    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;

    @EntryPoint()
    operation Main() : Unit {
        Message("Hello world!");
    }


    operation AllocateAndMeasure() : Result {
        use qubit = Qubit();
        return MResetZ(qubit);
    }

    operation Typed() : Unit {
        let result = LabeledResult("measurement one", Zero);

        // either
        let label = result::Label;
        let measurementResult = result::MeasurementResult;
        // or
        let (label, measurementResult) = result!;
    }

    operation Generics() : Unit {
        let labels = ["blue", "red", "green"];
        let labelTail = Tail(labels); // "green"

        let numbers = [1, 2, 3];
        let numberTail = Tail(numbers); // 3
    }

    operation Factorial() : Unit {
        let result = FactorialWithPreparation(2, Square);
    }

    function Exclude() : Unit {
        let values = [1, 2, 3, 4, 5];
        let padWithZero = Padded(_, 0, _);

        // produces [0,0,0,0,0,1,2,3,4,5]
        let padded = padWithZero(10, values);
        Message($"{padded}");
    }

    function Declarations() : Unit {
        // declare text1 as immutable
        let text1 = "hello";

        // declare text2 as mutable
        mutable text2 = "hello";
        set text2 = "world";
    }

    function Conditional(number : Int) : Unit {
        if number > 10 {
            Message("number > 10");
        } elif number > 0 {
            Message("0 < number <= 10");
        } else {
            Message("number <= 0");
        }

        let text = number > 10 ? "number > 10" | "number <= 10";
    }

    operation Loops() : Unit {
        let numbers = [1, 2, 3, 4, 5];
        for index in 0 .. Length(numbers)-1 {
            // can access array item via numbers[index]
        }

        for item in numbers {
            // can access array item via item variable
        }

        mutable counter = 1;
        repeat {
            // logic to execute on each iteration
            set counter += 1;
        } until counter > 5
        fixup {
            // logic to execute after each run
            // except for the final one
        }
    }

    function Range1() : Unit {
        let range1 = 1..4; // 1, 2, 3, 4
        let range2 = 1..2..5; // 1, 3, 5 
        let range3 = 3..-1..1; // 3, 2, 1
        let range4 = 3..2; // empty
    }

    function Array1() : Unit {
        let labels = ["green", "red", "blue"];
    }

    function Array2() : Unit {
        // ["", "", ""]
        mutable labels = ["", size = 3]; 

        // [0, "blue", 0]
        set labels w/= 1 <- "blue";
    }

    function Array3() : Unit {
        let labels1 = ["green", "red"];
        let labels2 = ["blue", "yellow"];

        // ["green", "red", "blue", "yellow"]
        let labels3 = labels1 + labels2;

        // ["green", "red", "orange"]
        let labels4 = labels1 + ["orange"];
    }

    function Array4() : Unit {
        let labels = ["green", "red", "blue", "yellow"];

        // ["red", "blue"]
        let slicedLabels1 = labels[1..2]; 

        // ["green", "blue"]
        let slicedLabels2 = labels[0..2..4]; 

        // ["blue", "red", "green"]
        let slicedLabels3 = labels[2..-1..0]; 

        // ["green", "red", "blue"]
        let slicedLabels4 = labels[...2]; 

        // ["red", "yellow"]
        let slicedLabels5 = labels[1..2...]; 

        // ["yellow", "blue", "red", "green"]
        let slicedLabels6  = labels[...-1...];
    }

    function Fail() : Unit {
        fail "Something bad happened!";
    }

    function Tuples() : Unit {
        let result = TupleFunction(100, true);
        let (num, txt) = TupleFunction(100, true);

        // with discard
        let (number, _) = TupleFunction(100, true);

        // equivalent to
        // let items = (100, true);
        // let result = TupleFunction(items);

        let reducedFunction = ComplexTupleFunction(5, _);

        // both work, but tuple can be omitted
        reducedFunction(("foo", true));
        reducedFunction("foo", true);
    }

    function TupleFunction(number : Int, flag : Bool) : (Double, String) {
        let result = (IntAsDouble(number), $"{flag}");
        return result;
    }

    function ComplexTupleFunction(number : Int, (data : String, flag : Bool)) : Unit {
    }

    function Convert() : Unit {
        let dblNumber = 1.;
        let intNumber = Truncate(dblNumber);
    }

    function StringInterpolation() : Unit {
        let index = 1;
        let result = One;
        let data = [1, 2, 3];
        Message($"Result of trial {index} is {result}. Data: {data}.");
    }

    function FactorialWithPreparation(input : Int, prepration : (Int -> Int)) : Int {
        let prepared = prepration(input);
        return FactorialI(prepared);
    }

    function Square(number : Int) : Int {
        return number * number;
    }

    newtype LabeledResult = (
        Label : String, 
        MeasurementResult : Result);

    operation QuantumTransformation(q : Qubit) : Unit is Adj + Ctl {
        // omitted for brevity
    }

    // this cannot be ported - there are no more attributes
    // @Attribute()
    // newtype MyAttribute = (Text : String);

    // @MyAttribute("Foo")
    // operation MyOperation() : Unit {}
}