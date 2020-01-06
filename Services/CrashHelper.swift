import Foundation

class CrashHelper {
    static func open() {
        app_old_exceptionHandler = NSGetUncaughtExceptionHandler()
        NSSetUncaughtExceptionHandler(RecieveException)
        self.setCrashSignalHandler()
    }
    
    private class func close() {
        NSSetUncaughtExceptionHandler(app_old_exceptionHandler)
    }
    
    private class func setCrashSignalHandler(){
        signal(SIGABRT, RecieveSignal)
        signal(SIGILL, RecieveSignal)
        signal(SIGSEGV, RecieveSignal)
        signal(SIGFPE, RecieveSignal)
        signal(SIGBUS, RecieveSignal)
        signal(SIGPIPE, RecieveSignal)
        signal(SIGTRAP, RecieveSignal)
    }
    
    private static let RecieveException: @convention(c) (NSException) -> Swift.Void = {
        (exteption) -> Void in
        if (app_old_exceptionHandler != nil) {
            app_old_exceptionHandler!(exteption);
        }
        
        let callStack = exteption.callStackSymbols.joined(separator: "\r")
        let reason = exteption.reason ?? ""
        let name = exteption.name
        let appinfo = appInfo()
        
        let model = CrashModel(type:CrashModelType.exception,
                               name:name.rawValue,
                               reason:reason,
                               appinfo:appinfo,
                               callStack:callStack)
    }
    
    private static let RecieveSignal : @convention(c) (Int32) -> Void = {
        (signal) -> Void in
        
        var stack = Thread.callStackSymbols
        stack.removeFirst(2)
        let callStack = stack.joined(separator: "\n")
        let reason = "Signal \(name(of: signal))(\(signal)) was raised.\n"
        let appinfo = appInfo()
        
        let model = CrashModel(type:CrashModelType.signal,
                               name:name(of: signal),
                               reason:reason,
                               appinfo:appinfo,
                               callStack:callStack)
        
        killApp()
    }
    
    private class func appInfo() -> String {
        let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") ?? ""
        let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? ""
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? ""
        let deviceModel = UIDevice.current.model
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        return "App: \(displayName) \(shortVersion)(\(version))\n" +
            "Device:\(deviceModel)\n" + "OS Version:\(systemName) \(systemVersion)"
    }
    
    
    private class func name(of signal:Int32) -> String {
        switch (signal) {
        case SIGABRT:
            return "SIGABRT"
        case SIGILL:
            return "SIGILL"
        case SIGSEGV:
            return "SIGSEGV"
        case SIGFPE:
            return "SIGFPE"
        case SIGBUS:
            return "SIGBUS"
        case SIGPIPE:
            return "SIGPIPE"
        default:
            return "OTHER"
        }
    }
    
    private class func killApp(){
        NSSetUncaughtExceptionHandler(nil)
        
        signal(SIGABRT, SIG_DFL)
        signal(SIGILL, SIG_DFL)
        signal(SIGSEGV, SIG_DFL)
        signal(SIGFPE, SIG_DFL)
        signal(SIGBUS, SIG_DFL)
        signal(SIGPIPE, SIG_DFL)
        
        kill(getpid(), SIGKILL)
    }
}

//--------------------------------------------------------------------------
// MARK: - GLOBAL VARIABLE
//--------------------------------------------------------------------------
private var app_old_exceptionHandler:(@convention(c) (NSException) -> Swift.Void)? = nil


//--------------------------------------------------------------------------
// MARK: - CrashModelType
//--------------------------------------------------------------------------


public enum CrashModelType:Int {
    case signal = 1
    case exception = 2
}

//--------------------------------------------------------------------------
// MARK: - CrashModel
//--------------------------------------------------------------------------
open class CrashModel: NSObject {
    
    open var type: CrashModelType!
    open var name: String!
    open var reason: String!
    open var appinfo: String!
    open var callStack: String!
    
    init(type:CrashModelType,
         name:String,
         reason:String,
         appinfo:String,
         callStack:String) {
        super.init()
        self.type = type
        self.name = name
        self.reason = reason
        self.appinfo = appinfo
        self.callStack = callStack
    }
}
