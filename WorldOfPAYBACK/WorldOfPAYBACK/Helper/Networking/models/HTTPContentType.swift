//
//  HTTPContentType.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

public enum HTTPContentType: CustomStringConvertible {
    case all
    case html
    case jpeg
    case png
    case json
    case multipartFormData(boundary: String)
    case pdf
    case text
    case custom(type: String)
    
    public var value: String {
        switch self {
        case .all:
            return "*/*"
        case .html:
            return "text/html"
        case .jpeg:
            return "image/jpeg"
        case .json:
            return "application/json"
        case .multipartFormData(let boundary):
            return "multipart/form-data; boundary=\(boundary)"
        case .pdf:
            return "application/pdf"
        case .png:
            return "image/png"
        case .text:
            return "text/plain"
        case .custom(let type):
            return type
        }
    }
    
    public var description: String {
        value
    }
}
