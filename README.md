# How to Code: Simple Data

## Systematic Program Design

## Course 1 of 6 in the Edx Micro-masters in Software Development

space-invaders.rkt was my final project for this first course in the micro-masters program. The final project encapsulated everything covered in the course, including: data definitions, templating functions, as well as the 'how to design functions' recipe.

The rest of this README is dedicated to the notes I took during the 6-week period I followed the course.

## Introduction

This course focuses on 'systematic program design,' which defines a step-by-step approach to identifying and designing data and functions. Systematic program design helps you introduce clear patterns of development into your program that make your programs easier to read, interpret, and extend. It helps you break down programs in neat pieces, and when you have a program broken down correctly, it is formed of nice pieces that are composable and re-usable.

### Primitives and expressions in the BSL Language

A call to a primitive must have operands that are values or evaluate to values.

To evaluate a primitive call, first reduce the operands to values and then apply the primitive operator to those values.

This is applicable when an operand is itself an expression

Evaluation of an expression proceeds from left to right -> this is the primitive call rule

This is the first evaluation rule, also known as the primitive call rule. It allows us to write expressions of arbitrary complexity in that operands can themselves be expressions. This provides a lot of flexibility in how you write expressions. Indeed, repeated application of this rule leads to left to right evaluation of expressions.

Readability and changeability are two of the most important qualities a program can have. That's what makes robust programs

Functions help us above all, avoid repetition.

To evaluate a primitive call:

* first reduce operands to values
* then apply the primitive to those values

To evaluate a function call:

* first reduce operands to values (called arguments)
* replace the function call by the body of the function definition in which every occurrence of parameter(s) is replaced by the corresponding argument value

Predicates are primitives or functions that produce a boolean value. If statements evaluate predicates.

## Module 1b: How to design Functions

### On Functions in programming

The approach taught in this module is also know as HTDF
As a general rule, we don't want functions to do more than one task. If a function is handling more than one task. you should break it up into more than one function. The 'main' function here can call a 'helper' function.

### Learning Goals

* Be able to use the How to Design Functions (HtDF) recipe to design functions that operate on primitive data.
* Be able to read a complete function design and identify its different elements.
* Be able to evaluate the different elements for clarity, simplicity and consistency with each other.
* Be able to evaluate the entire design for how well it solves the given problem.

Every step in the recipe is intended to help us write the steps after it. It allows you to slowly build up the knowledge you need to build the function

A Note on systematic program design

This ability to work on programs by reasoning about them at a model level
is one of the things that really separates program designers from people who happen to write code that works.

### The 'How To Design Functions' recipe (HTDF)

#### 1) Signature, purpose and stub.

The signature tells us what type of data the function consumes, and what type of data is produces (or returns)

```
;; Number -> Number
;; --- or on custom types ---
;; ListOfString -> ListOfString
```

The purpose is a one-line description of what the function produces in terms of what it consumes.

```
;; Produce 2 times the given number n
```

The stub is the function definition that returns, or produces a dummy result of the correct type. It will be deleted later at the end of the recipe.

#### 2) Define examples, wrap each in check-expect.

Multiple examples of calling the function help us understand what the function must do. Because we wrap them in 'check-expect' (assertion statements), these examples also serve as unit tests for the completed function. These are unit tests, and above all, unit tests greatest utility is that they provide examples for how a given function should work, or what it should output given an input.

```
(check-expect (double 5) 10)
```

#### 3) Template and inventory.

The body of the template is the outline of the function. It defines the parameter(s) as well as the function name. You also won't keep a copy of the template when finished writing the function.

```
(define (double n)
     (...n))
```

#### 4) Code the function body.

Then you copy the template, comment out the template and write the function body.

```
(define (double n)
     (* n 2))
```

### Test and debug until correct

The goal of tests is that you should have complete code coverage, meaning that your tests should cover all code written in a function. For example, a test suite does not have total code coverage if the function contains an if statement and the false condition is not met. Often, you end up making a lot of decisions about the behavior of functions as you write their tests, hence why it makes sense to write tests prior to coding the function body.
Unit Tests are often examples before they are tests. Their primary use is to function as examples to show how certain functions work.

#### Section2: Module How to Design Data

While systems tend to have more function designs than data designs, the design of the data turns out to drive the design of the functions. So data design is a critical part of program design.

Designing data tends to be a 'point of leverage' in designing programs. In other words it is the starting point, and determines how the rest of your program is written.

The `cond` statement is a multi-armed conditional. It provides more than 2 options. It is the same as a switch statement in JavaScript.
`cond` is used instead of if when we have multiple parallel cases.

In any program, we have something called a problem domain. For example, if you have a program that controls traffic lights, then that program's problem domain has to do with traffic, simulation of traffic, and care roads, etc.

Representing information in the problem domain is using data in a program. For example, representing "a traffic light is red" in your program requires some sort of 'data modeling' of that information. We represent that some light might be red using the natural number 0, for example.

A data definition can tell us everything we need to know about how to represent information as data.

### Data Definition Formula

Data definitions are a driving element in the design recipes.

A data definition establishes the represent/interpret relationship between information and data:

Information in the program's domain is represented by data in the program.
Data in the program can be interpreted as information in the program's domain.
A data definition must describe how to form (or make) data that satisfies the data definition and also how to tell whether a data value satisfies the data definition. It must also describe how to represent information in the program's domain as data and interpret a data value as information.

**The structure of the information** in the program's domain determines the kind of data definition used. This in turn determines the templates for the functions we use in our program, which ultimately impacts the overall structure of our program.

Identifying the structure of information is the key step in effective program design.

In a given program, there tend to be many functions that consume a single data 'type' defined by a data definition (one data definition to many functions). In the examples we look at, there's usually only one function for one data definition to simply illustrate the concept of data definitions. You do not normally design a separate data definition for each function.

Often you'll have to parts to your file: A section for data definitions and another for the functions that operate on that data.

Design is all about going from ill-formed problems to well-structured solutions.

### How To Design Data Recipe

#### 1.) A possible structure definition (not until compound data)

```
(define-struct school (name tuition))
```

#### 2.) A type comment that defines a new type name and describes how to form data of that type.

```
;; For compound data
;; School is (make-school String Natural)

;; For enumeration
;; TrafficLight is enumeration, is one of:
;; - "red": String
;; - "yellow": String
;; - "green": String

;; For Lists (compound technically)
;; ListOfSchool is one of:
;; - empty
;; - (cons School ListOfSchool) .     ;;   Reference rule and self-reference
```

#### 3.) An interpretation that describes the correspondence between information and data.

```
;; For compound data
;; interp. name is the school's name, tuition is international-students tuition in USD

;; For enumeration
;; interp. the color of a traffic light

;; For Lists (compound technically)
;; interp. a list of schools
```

#### 4.) One or more examples of the data as Constants. For more complex data definitions, examples are especially useful.

```
;; <examples are redundant for enumerations>
;; (define S1 (make-student "Sally" 10000))
```

#### 5.) A template for a 1 argument function operating on data of this type.

```
(define (fn-for-school s)
  (... (school-name s)
  (school-tuition s)))

;; Template rules used:
;; - compound: (make-school String Natural)

(define (fn-for-los los)
  (cond [(empty? los) (...)]
  [else
  (... (fn-for-school (first los))
  (fn-for-los (rest los)))]))

;; Template rules used:
;; - one of: 2 cases
;; - atomic distinct: empty
;; - compound: (cons School ListOfSchool)
;; - reference: (first los) is School
;; - self-reference: (rest los) is ListOfSchoolData Definitions: Additional info and using templates

;; Template
#;
(define (fn-for-trafficlight tl)
  (cond [(string=? "red" tl) (...)]
  [(string=? "yellow" tl) (...)]
  [(string=? "green" tl) (...)]))

;; Template rules used:
;; one of 3 cases:
;; - atomic distinct: "red"
;; - atomic distinct: "yellow"
;; - atomic distinct: "green"
```

### Conclusion on data definitions

Data Definitions describe how to form data of new types, how to represent information as data, how to interpret data as information, and provides a template for operating on data.

Data definitions make programs much more meaningful to other programmers.

They help us understand how information can be interpreted as data.

When you define new data types, you are defining non-primitive data

The recipes we've seen so far are 'orthogonal to the form of data,' which means 'mostly independent to the form of data.'

## Non-Primitive Forms of Data

**Atomic non-primitive data**

Use simple atomic data when the information to be represented is itself atomic in form, such as the elapsed time since the start of the animation, the x coordinate of a car or the name of a cat. Atomic distinct means there is a single distinct value.

**Enumeration**

Enumerations consist of a fixed number of distinct items. Like for example 3 distinct Letter Grades in a school (e.g A, B, C). With enumeration you use a 'one of statement' in the type definition

```
;; Type Comment
;; LetterGrade is one of:
;; - "A"
;; - "B"
;; - "C"
```

Note that Examples are unnecessary for enumerations. You don't need to say 'define A means A... and so forth'

**Interval**

Interval data definitions are used for information that is numbers within a certain range.

```
;; Countdown is Integer[0, 10]
;; interp. the number of seconds remaining to liftoff
(define C1 10) ; start
(define C2 5) ; middle
(define C3 0) ; end
```
