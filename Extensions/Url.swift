import Foundation

extension URL {
    var withoutPath: URL? {
        guard let scheme = self.scheme else { return nil }
        guard let host   = self.host   else { return nil }
        return URL(string: scheme.appending("://").appending(host).appending("/"))
    }
    
    var queryParams: [String: String]? {
        if query == nil {
            return nil
        }
        var dict: [String: String] = [:]
        URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems?
        .forEach({ (queryItem) in
            dict[queryItem.name] = queryItem.value
        })
        return dict.isEmpty ? nil : dict
    }
    
    func appendingQueryComponents(dict: [String: String]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        urlComponents.queryItems = dict.map({URLQueryItem(name: $0.key, value: $0.value)})
        
        return urlComponents.url
    }
    
    func excludingQueryItems(named: String) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true), urlComponents.queryItems != nil else {
            return self
        }
        
        urlComponents.queryItems?.removeAll { (queryItem) -> Bool in
            return queryItem.name.elementsEqual(named)
        }
        
        return urlComponents.url ?? self
    }
    
    func excludingQueryItems(named: [String]) -> URL {
        var url = self
        named.forEach { (name) in
            url = self.excludingQueryItems(named: named)
        }
        return url
    }
}

extension URLResponse {
    var code: Int {
        guard let httpResponse = self as? HTTPURLResponse else { return 0 }
        return httpResponse.statusCode
    }
    
    var isSuccessful: Bool {
        guard let httpResponse = self as? HTTPURLResponse else { return false }
        return httpResponse.statusCode / 100 == 2
    }
    
    var isRedirect: Bool {
        guard let httpResponse = self as? HTTPURLResponse else { return false }
        return httpResponse.statusCode / 100 == 3
    }
}
