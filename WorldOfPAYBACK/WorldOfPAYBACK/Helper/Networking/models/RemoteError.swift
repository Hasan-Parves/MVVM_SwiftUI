//
//  RemoteError.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//
import Foundation

public enum RemoteError: Error, Equatable, CustomStringConvertible {
    case authorizationRequired
    /// For HTTP client errors (400-499)
    case badRequest(statusCode: Int)
    case badResponse(URLResponse)
    case badURL
    case invalidData
    case unexpectedState
    
    public var description: String {
        switch self {
        case .authorizationRequired:
            return "Authorization required"
        case .badResponse(let response):
            return "Bad response (\(response))"
        case .badRequest(statusCode: let statusCode):
            return "Bad request (status: \(statusCode))"
        case .badURL:
            return "Bad URL"
        case .invalidData:
            return "Invalid data"
        case .unexpectedState:
            return "Unexpected state"
        }
    }
}
