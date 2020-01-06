UNUserNotificationCenter.current().getNotificationSettings { (settings) in
    if settings.authorizationStatus == .authorized {
        // Already authorized
    }
    else {
        // Either denied or notDetermined
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // add your own
            UNUserNotificationCenter.current().delegate = self
            let alertController = UIAlertController(title: "Notification Alert", message: "please enable notifications", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            DispatchQueue.main.async {
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
}
