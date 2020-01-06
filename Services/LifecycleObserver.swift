import UIKit

extension TrackerHelper: UNUserNotificationCenterDelegate {
    
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
        if let url = note.userInfo?[UIApplication.LaunchOptionsKey.url] as? URL {
            TrackerHelper.shared.handleUrl(url)
        }
        TrackerHelper.shared.launchOptions = note.userInfo as? [UIApplication.LaunchOptionsKey: Any]
    }
    
    @objc private func willTerminate() {
    }
    
    @objc private func willResignActive() {
    }
    
    @objc private func didBecomeActive() {
        
        if isLoaded {
            tutV?.setTutView()
            Events.check()
        }
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
        UserDefaults.standard.hasBeenLaunchedBefore = true
        TrackerHelper.shared.observe()
        Statistics.startTime = getTime()
    }()

    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}
