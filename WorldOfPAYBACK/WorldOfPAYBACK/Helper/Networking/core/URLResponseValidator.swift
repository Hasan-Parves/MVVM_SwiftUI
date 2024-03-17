//
//  URLResponseValidator.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

public protocol URLResponseValidator {
    func validate(response: URLResponse, data: Data) throws
}

public struct HTTPURLResponseValidator: URLResponseValidator {
    public init() {}
    
    public func validate(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RemoteError.badResponse(response)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 400...499:
            throw RemoteError.badRequest(statusCode: httpResponse.statusCode)
        default:
            throw RemoteError.badResponse(response)
        }
    }
}
