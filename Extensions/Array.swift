import Foundation

extension Array where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
}

extension Dictionary where Key == String {
    
    func valuesToString() -> [String: String]? {
        var newDict = [String: String]()
        
        forEach({ (key, value) in
            if let stringValue = (value as? CustomStringConvertible)?.description {
                newDict[key] = stringValue
            }
        })
        
        return newDict.isEmpty ? nil : newDict
    }
}
