import UIKit

class LifecycleObserver: UNUserNotificationCenterDelegate {
    
    func observe() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(willTerminate),
                         name: UIApplication.willTerminateNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(willResignActive),
                         name: UIApplication.willResignActiveNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(didBecomeActive),
                         name: UIApplication.didBecomeActiveNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(didFinishLaunching(_:)),
                         name: UIApplication.didFinishLaunchingNotification,
                         object: nil)
    }
    
    @objc private func didFinishLaunching(_ note: Notification) {
    }
    
    @objc private func willTerminate() {
    }
    
    @objc private func willResignActive() {
    }
    
    @objc private func didBecomeActive() {
    }
    
    @objc private func remoteNotificationRecieved() {
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
}

// MARK: - framework initialization
extension UIApplication {

    private static let runOnce: Void = {
        // make your initialisation here
    }()

    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}
