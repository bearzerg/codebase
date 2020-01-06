import UIKit

public var isFirstLaunch: Bool {
    return !UserDefaults.standard.hasBeenLaunchedBefore
}
public var isLoaded: Bool {
    return UserDefaults.standard.linkCash != nil
}

func ifDebug(_ completion: () -> ()) {
    #if DEBUG
    completion()
    #endif
}

func getTime() -> Float {
    return (Float(CACurrentMediaTime()) * 100).rounded() / 100
}

func whatTimeIsIt(funcName: String = #function) {
    print("\(funcName): \(getTime())")
}
