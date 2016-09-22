# THIS PROJECT IS NO MORE SUPPORTED

I've decided to build a nice mock framework for Swift with code-generation. And, yes, I made it work. However, we can not use this solution or even this kind of solution on big projects due to significantly long compilation time of the project itself and the tests. Automatically generated mocks will produce too much code and building unit test target will last like forever. Swift compiler is poorly optimized, and it seems that it wouldn't be changed in future. Apple prefers to add more "features" and break backward compatibility than making Swift compiler faster and more stable. P.S. Sorry for my rageful English.

---

# Switt

Tool Kit for reading Swift code

# Welcome to Switt project.

Switt is a framework for reading Swift files into nice structures and generating nice code from these structures. It is in a very early stage of development, however, every contribution is welcomed.

The project is under MIT license. The project is non-profit.

This project is only used in the boilerplate-free mock framework I've recently released to public (it's still unusable):
- Framework: https://github.com/SwiftTools/Swick
- Generator: https://github.com/SwiftTools/SwickGen

This project uses ANTLRv4 and my framework with Swift grammar: https://github.com/SwiftTools/SwiftGrammar

# How to build

This project has no examples and has no practical usage yet. However, if you decide to participate, here's howto:

1. ```carthage update --platform osx  --no-use-binaries```
1. Open xcodeproj
1. Run tests


# Support or Contact

Contact me via skype: artyom(d-o-t)razinov, or mail artyom(d-o-t)razinov@gmail.com
