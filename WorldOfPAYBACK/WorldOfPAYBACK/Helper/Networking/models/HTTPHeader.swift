//
//  HTTPHeader.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

public enum HTTPHeader: CustomStringConvertible, Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.key == rhs.key
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    case accept(_ types: [HTTPContentType])
    case acceptLanguage
    case authorization(_ value: String)
    case contentType(_ type: HTTPContentType)
    case custom(key: String, value: String)
        
    fileprivate var key: String {
        switch self {
        case .accept:
            return "Accept"
        case .acceptLanguage:
            return "Accept-Language"
        case .authorization:
            return "Authorization"
        case .contentType:
            return "Content-Type"
        case .custom(let key, _):
            return key
        }
    }
    
    fileprivate var value: String {
        switch self {
        case .accept(let types):
            return types.map(\.value).joined(separator: ", ")
        case .acceptLanguage:
            return Locale.current.language.languageCode?.identifier ?? "en"
        case .authorization(let value):
            return value
        case .contentType(let type):
            return type.value
        case .custom(_, let value):
            return value
        }
    }
    
    public var description: String {
        "\(key): \(value)"
    }
}

public extension Set<HTTPHeader> {
    func asDictionary() -> [String: String]? {
        if isEmpty { return nil }
        return Dictionary(uniqueKeysWithValues: map { ($0.key, $0.value) })
    }
}
