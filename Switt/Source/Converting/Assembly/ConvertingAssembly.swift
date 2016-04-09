protocol ConvertingAssembly {
    func converter() -> ConvertingAssemblyUniversalConverter
    
    // Utility:
    func declarationContextsScanner() -> DeclarationContextsScanner
}