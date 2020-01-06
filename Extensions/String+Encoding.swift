import Foundation

extension Data {
    var toString: String? {
        return String(data: self, encoding: .utf8)
    }
}

extension String {
    
    subscript(i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    enum EncodingType {
        case base
        case doubleBase
    }
    
    func decode(with method: EncodingType = .base) -> String? {
        switch method {
        case .base:
            return Data(base64Encoded: self)?.toString
        case .doubleBase:
            return decode()?.decode()
        }
    }
    
    func encode(with method: EncodingType = .base) -> String? {
        switch method {
        case .base:
            return self.data(using: .utf8)?.base64EncodedString()
        case .doubleBase:
            return encode()?.encode()
        }
    }
}
