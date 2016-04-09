import SwiftGrammar

struct FuncData: Func {
    var name: String
    var accessibility: Accessibility
    var parameters: [Parameter]
    var returnType: Type
}