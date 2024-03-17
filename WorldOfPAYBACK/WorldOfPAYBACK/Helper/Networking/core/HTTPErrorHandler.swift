//
//  HTTPErrorHandler.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

public protocol HTTPErrorHandler {
    func handleError<T: HTTPEndpoint>(_ error: Error, for endpoint: T) async throws -> T.Decoder.ResultType
}

public struct RethrowingHTTPErrorHandler: HTTPErrorHandler {
    public init() {}
    
    public func handleError<T: HTTPEndpoint>(_ error: Error, for endpoint: T) async throws -> T.Decoder.ResultType {
        throw error
    }
}
