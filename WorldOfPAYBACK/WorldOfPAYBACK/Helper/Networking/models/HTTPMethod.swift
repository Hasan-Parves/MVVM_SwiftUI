//
//  HTTPMethod.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

public enum HTTPMethod: String, CustomStringConvertible, CaseIterable {
    case get = "GET"

    // Add those later when Payback Backend-Team provided API also add test
    /*
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
     */
    
    public var description: String {
        rawValue
    }
}
