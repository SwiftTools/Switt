# Switt

Tool Kit for reading Swift code

# Welcome to Switt project.

Switt is a framework for reading Swift files into nice structures and generating nice code from these structures. It is in a very early stage of development, however, every contribution is welcomed.

The project is under MIT license. The project is non-profit. I will hide my name from this TODO if anyone else will participate (or put here his/her name).

The main goal of this project is a lack of such frameworks. Originally I've started mock generating project like Cuckoo, which is now not ready, because of lack of tools.

# TODO (prior first)

1. Commit changes with code generation if anyone else is interested in this project
1. Find collaborators
1. Implement scanning generic placeholders from String: SourceKit doesn't provide such information =(
1. Implement type inference

# What will be supported on the next minor release (very urgent)

1. Any primitive parsing of protocols with methods and properties (may be not all cases, e.g.: no generics)
1. Generation of primitive protocol with methods and properties (may be not all cases, e.g.: no generics)

# What will be supported on the next major release

1. Reading all declarations with bodies as String (methods' bodies, statements, expressions)
1. Generating all declarations with bodies as String
1. Generic placeholders (<T, U where U.Something == T>)

# What will be supported in far future

1. Type inference
1. Statements and expressions
1. Configurable code generation

# Support or Contact

Contact me via skype: artyomrazinov (with a dot between m and r), or mail @gmail.com
