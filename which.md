# Which in Bourne shell
##### by Harrys Kedjnane

## Introduction
```which``` is a program that takes at one or more strings as an input and checks whether there is a corresponding executable in the environment's ```PATH```.

The environment's ```PATH``` is defined by the ```PATH``` environment variable. It contains a list of directories separated by a colon ```:```.
By default, ```which``` stops once it finds one occurrence of the executable, however the flag ```-a``` can be passed in order to check for multiple occurences of an executable in the ```PATH```.

## Goal

OpenBSD has its own implementation of ```which```, which is written in C and can be found [here](https://github.com/openbsd/src/tree/master/usr.bin/which).
Our goal is to implement the same behavior as OpenBSD's implementation, but written entirely in shell script.

## Approach

There are 3 sources by which we should abide when implementing our script:

- The ```which``` executable, to test the program's behavior with different inputs
- The ```man``` page of the program detailing its behavior (can be found [here](https://man.openbsd.org/which))
- The previously mentioned source code

Using these sources to verify and test our work, we can write our implementation and compare it to the original behavior.

## Implementation
We must take care to implement our script in such a way that it relies on external programs as little as possible.
Moreover and as instructed, I make extensive use of shell constructs such as booleans and the IFS.

The implementation was relatively simple. The difficulty was to implement the behavior faithfully as some behaviors were not immediately obvious.
For example, it did not originally occur to me that ```which``` should check whether the program found in the path is actually executable. But the change was trivial once I figured this out.

## Conclusion
Using the executable, its ```man``` page and the source code for OpenBSD's ```which```, I implemented the program's behaviour in shell script. The script is simple but figuring out the program's features and quirks took some time. Once the script was done, it was easy to check its correctness against the official implementation.
