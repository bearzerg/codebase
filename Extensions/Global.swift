import UIKit

func ifDebug(_ completion: () -> (),
             funcName: String = #function,
             fileName: String = #file,
             lineNumber: Int = #line) {
    #if DEBUG
    print("\(fileName).\(funcName)-\(lineNumber) at \(getTime()):\n")
    completion()
    #endif
}

func getTime() -> Float {
    return (Float(CACurrentMediaTime()) * 100).rounded() / 100
}

func whatTimeIsIt(funcName: String = #function) {
    print("\(funcName): \(getTime())")
}
