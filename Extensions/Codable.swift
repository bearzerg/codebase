import Foundation

extension Encodable {
    var json: Data? {
        guard let json = try? JSONEncoder().encode(self) else { return nil }
        return json
    }
    
    var jsonPrettified: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let json = try? encoder.encode(self) else { return nil }
        return json
    }
    
    var dictionary: [String: String]? {
        
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap({ $0 as? [String: Any] })?.valuesToString()
    }
}

extension Decodable {
    static func decode(json: Data) -> Self? {
        return try? JSONDecoder().decode(Self.self, from: json)
    }
}
