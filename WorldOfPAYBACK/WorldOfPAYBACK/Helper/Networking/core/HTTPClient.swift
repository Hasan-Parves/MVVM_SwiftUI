//
//  HTTPClient.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Combine
import Foundation

public protocol DataProvider {
    func data(for: URLRequest) async throws -> (Data, URLResponse)
    
    var urlSession: URLSession? { get }
}

public struct HTTPClient {
    private let dataProvider: any DataProvider
    private var errorHandler: any HTTPErrorHandler
    private let shouldUseTestServer: Bool
    private let logger: Logger?
    
    public init(
        dataProvider: any DataProvider = URLSession.shared,
        errorHandler: any HTTPErrorHandler = RethrowingHTTPErrorHandler(),
        shouldUseTestServer: Bool = false,
        logger: (any Logger)? = nil
    ) {
        self.dataProvider = dataProvider
        self.errorHandler = errorHandler
        self.shouldUseTestServer = shouldUseTestServer
        self.logger = logger
    }
    
    public func request<T: HTTPEndpoint>(_ endpoint: T) async throws -> T.Decoder.ResultType {
        let logger = T.logger ?? logger
        do {
            
            // TODO:: Handle authorization string here in future
            // var authorizationHeader: String?
            let request = try URLRequest(endpoint: endpoint)
            logger?.log(request: request)
            
            let bodyData: Data
            let response: URLResponse
            if let urlSession = dataProvider.urlSession {
                let (asyncBytes, urlResponse) = try await urlSession.bytes(for: request)
                
                let length = urlResponse.expectedContentLength
                
                var data = Data()
                data.reserveCapacity(Int(length))
                
                for try await byte in asyncBytes {
                    try Task.checkCancellation()
                    data.append(byte)
                }
                bodyData = data
                response = urlResponse
            } else {
                let (data, urlResponse) = try await dataProvider.data(for: request)
                bodyData = data
                response = urlResponse
            }
            
            logger?.log(response: response)
            logger?.log(data: bodyData)
            
            try endpoint.validator.validate(response: response, data: bodyData)
            
            let result = try endpoint.decoder.decode(data: bodyData)
            logger?.log(result: result, for: request)
            
            return result
        } catch {
            logger?.log(error: error, for: endpoint)
            
            return try await errorHandler.handleError(error, for: endpoint)
        }
    }
}

extension URLSession: DataProvider {
    public var urlSession: URLSession? { self }
}
