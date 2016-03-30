# Switt

Tool Kit for reading Swift code

# Welcome to Switt project.

Switt is a framework for reading Swift files into nice structures and generating nice code from these structures. It is in a very early stage of development, however, every contribution is welcomed.

The project is under MIT license. The project is non-profit.

Originally I've started mock generating project like Cuckoo, which is now not ready, because of lack of tools.

# History of development

1. Mar 8: Initial commits, simple scanning for declarations with SourceKitten (I also made helper project SwiftFelisCatus)
1. Mar 13: I realized that Source Kit can't provide some info and has errors and I moved towards implementing lexical analysis. I made simple grammar and parser.
1. Mar 21: I read Dragon Book and realized that I was completely wrong. I implement proper lexer that tokenizes character stream
1. Mar 30: Finished parser. Implement transformations of grammar. Faced with the problem with performance. It is really slow, but it is enough to start developing other parts of code

# Plans

1. Implement scanning declarations into nice struct with Source Kit and with a help of previously made lexical analyzer.
1. Start developing mock framework
1. Maybe to improve performance at this stage, if I can find free time.
1. After mock framework will be stable I will improve performance.
1. I have an idea to create structs for syntax tree. E.g.: you want to handle about 10 cases of declarations, not all 253 rules. So you want a nice enum with only 10 cases for declarations. This can be done using code generation. 

# Support or Contact

Contact me via skype: artyom(d-o-t)razinov, or mail artyom(d-o-t)razinov@gmail.com
