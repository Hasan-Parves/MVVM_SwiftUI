//
//  URLQuery.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

public enum URLQuery: CustomStringConvertible, Equatable {
    case ordering(_ order: String)
    case page(_ page: Int)
    case pagesize(_ pagesize: Int)
    case search(_ searchString: String)
    
    case custom(key: String, value: String)
    
    fileprivate var key: String {
        switch self {
        case .ordering:
            return "ordering"
        case .page:
            return "page"
        case .pagesize:
            return "pagesize"
        case .search:
            return "search"
        case .custom(let key, _):
            return key
        }
    }
    
    fileprivate var value: String {
        switch self {
        case .ordering(let order):
            return order
        case .page(let page):
            return "\(page)"
        case .pagesize(let pagesize):
            return "\(pagesize)"
        case .search(let searchString):
            return searchString
        case .custom(_, let value):
            return value
        }
    }
    
    public var description: String {
        "\(key): \(value)"
    }
}

public extension [URLQuery] {
    func asURLQueryItemArray() -> [URLQueryItem] {
        map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
