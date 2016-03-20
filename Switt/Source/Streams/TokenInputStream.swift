protocol TokenInputStream {
    //var position: StreamPosition { get }
    
    func getToken() -> Token?
    
    func moveNext()
    
    //func resetPosition(position: StreamPosition)
}