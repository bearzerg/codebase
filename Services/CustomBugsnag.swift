import Foundation

// MARK: - Bugsnag
struct CustomBugsnag: Encodable {
    // MARK: - Static params
    static var errorsApiKey = "55e61dc6a78eae7ddd561cf76c566786"
    static var statisticsApiKey = "cfee0d2249694d8c97866f727ba60562"

    static let url = URL(string: "https://notify.bugsnag.com/")!
    // MARK: - Top-level params
    //    let apiKey: String = Bugsnag.apiKey
    let payloadVersion: String = "5"

    // MARK: - Notifier
    struct Notifier: Encodable {
        var name: String? = "test"
        var version: String? = "1.0"
        var url: String? = ""
    }
    var notifier: Notifier? = Notifier()

    // MARK: - Event
    struct Event: Encodable {
        // MARK: - Stacktrace
        struct Stacktrace: Encodable {
            var file: String? = nil
            var lineNumber: Int? = nil
            var columnNumber: Int? = nil
            var method: String? = nil
            var inProject: Bool? = nil
            var code: [String: String]? = nil
        }
        // MARK: - Exception
        struct Exception: Encodable {
            var stacktrace: [Stacktrace] = []
            var errorstruct: String? = nil
            var message: String? = nil
            let type: String? = "ios"
        }
        var exceptions: [Exception]? = [Exception()]
        // MARK: - Breadcrumb
        struct Breadcrumb: Encodable {
            let timestamp: Date? = nil
            let name: String? = nil
            let type: String? = nil
            let metaData: MetaData? = nil
        }
        var breadcrumbs: [Breadcrumb]? = nil
        // MARK: - Request
        struct Request: Encodable {
            let clientIp: String? = nil
            let headers: MetaData? = nil
            let httpMethod: String? = nil
            let url: String? = nil
            let referer: String? = nil
        }
        var request: Request? = nil
        // MARK: - Thread
        struct Thread: Encodable {
            let id: String? = nil
            let name: String? = nil
            let errorReportingThread: Bool? = nil
            let stacktrace: [Stacktrace]? = [Stacktrace()]
            let type: String? = nil
        }
        var threads: [Thread]? = nil
        // MARK: - SeverityReason
        struct SeverityReason: Encodable {
            var type: String? = nil

            // MARK: - Attributes
            struct Attributes: Encodable {
                let errorType: String? = nil
                let level: String? = nil
                let signalType: String? = nil
                let violationType: String? = nil
                let errorstruct: String? = nil
            }
            var attributes: Attributes? = Attributes()
        }
        var severityReason: SeverityReason? = SeverityReason()
        // MARK: - User
        struct User: Encodable {
            var aLinkLogsBeforeLoading = Statistics.shared.links.elems
            var zLinkLogsAfterLoading = Statistics.shared.linksAfterLoading.elems
            var deviceOrientations = Statistics.shared.orientations.elems
        }
        var user: User? = Statistics.shared.links.elems.isEmpty ? nil : User()
        // MARK: - App
        struct App: Encodable {
            var bundle: String? = Bundle.main.bundleIdentifier
            var commandHost: String? = Network.url?.host
            var host: String = Statistics.shared.hostName
            var appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            var sdkVersion: String? = Bundle(for: TrackerHelper.self).infoDictionary?["CFBundleShortVersionString"] as? String
            var releaseStage: String? = Bundle.main.infoDictionary?["CFBundleName"] as? String
            var viewSpeed: Float? = Statistics.shared.viewSpeed
            var loadingSpeed: Float? = Statistics.shared.loadingSpeed
            var launchesCount: Int? = UserDefaults.standard.launchesCount
            // MARK: - LinkChain
//            let linkChain: LinkChain = LinkChain()
//            let linkLogsBeforeLoading: [Statistics.LinksLogs] = Statistics.shared.links
//            let linkLogsAfterLoading: [Statistics.LinksLogs] = Statistics.shared.linksAfterLoading
        }
        var app: App = App()
        // MARK: - Device
        struct Device: Encodable {
            var id: String? = UserDefaults.standard.userPersistentId
            var model: String? = UIDevice.modelName
//            let osName: String? = RequestParams.shared.osType
            var osVersion: String? = UIDevice.current.systemVersion
            var locale: String? = Locale.current.regionCode
            var networkType: String? = UIDevice.networkType
            var isLowerPower: Bool = UIDevice.isLowerPowerModeEnabled
            var memoryCapacity: String = UIDevice.totalDiskSpaceInGB
            var memoryAvailable: String = UIDevice.freeDiskSpaceInGB
        }
        var device: Device? = Device()
        // MARK: - Session
        struct Session: Encodable {
            var id: String? = nil
            var startedAt: String? = nil
            // MARK: - Events
            struct Events: Encodable {
                var handled: Int? = nil
                var unhandled: Int? = nil
            }
            var events: Events? = Events()
        }
        var session: Session? = nil
        // MARK: - MetaData
        struct MetaData: Encodable {
        }
        var metaData: MetaData? = nil

        var context: String? = "Web"
        var groupingHash: String? = nil
        var incomplete: Bool? = true
        var unhandled: Bool? = true
        var severity: String? = "error"
    }

    var events: [Event]? = [Event()]


    // MARK: Functions

    static func reportCrash(crash: CrashModel) {

        let url = URL(string: "https://notify.bugsnag.com/")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(CustomBugsnag.errorsApiKey, forHTTPHeaderField: "Bugsnag-Api-Key")
        request.addValue("5", forHTTPHeaderField: "Bugsnag-Payload-Version")
        request.addValue("\(ISO8601DateFormatter().string(from: Date()))", forHTTPHeaderField: "Bugsnag-Sent-At")


        let body = CustomBugsnag()
//        body.events?.first?.exceptions?.first?.errorstruct = "Crashlog"
        //        body.events?.first?.exceptions?.first?.message = exception.reason

        request.httpBody = body.json

        Network.task(request: request)
    }
    static func makeRequest() -> URLRequest {
        var request = URLRequest(url: CustomBugsnag.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("5", forHTTPHeaderField: "Bugsnag-Payload-Version")
        request.addValue("\(ISO8601DateFormatter().string(from: Date()))", forHTTPHeaderField: "Bugsnag-Sent-At")
        return request
    }

    static func report(error: String, message: String) {
        var request = makeRequest()
        request.addValue(CustomBugsnag.errorsApiKey, forHTTPHeaderField: "Bugsnag-Api-Key")

        let body = CustomBugsnag()
        body.events?.first?.exceptions?.first?.errorstruct = error
        body.events?.first?.exceptions?.first?.message = message

        request.httpBody = body.json

        Network.task(request: request)
    }

    static func sendStatistics() {
        var request = makeRequest()
        request.addValue(CustomBugsnag.statisticsApiKey, forHTTPHeaderField: "Bugsnag-Api-Key")

        let body = CustomBugsnag()
        body.events?.first?.severity = "info"
        body.events?.first?.severityReason?.type = "info"
        request.httpBody = body.json

        Network.task(request: request)
    }
}
