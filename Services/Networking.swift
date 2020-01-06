import Foundation

class Network {
    static var url: URL?
    
    static func send(url: URL, method: String, body: Data? = nil, completion: ((Data) -> ())? = nil) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        task(request: request, completion: completion)
    }
    
    static func task(request: URLRequest, completion: ((Data) -> ())? = nil) {

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
//                CustomBugsnag.report(error: error.localizedDescription, message: "Status code: \(response.code)")
                return
            }
            
            guard let data = data else { return }
            
            completion?(data)
            
        }.resume()
    }
}
