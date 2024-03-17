//
//  URLRequestExtension.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

public extension URLRequest {
    init(endpoint: some HTTPEndpoint, shouldUseTestServer: Bool = false, authorizationHeader: String? = nil) throws {
        var components = URLComponents(string: "\(endpoint.scheme)")
        if shouldUseTestServer {
            components?.path = "/\(endpoint.testBasePath)\(endpoint.path)"
        } else {
            components?.path = "/\(endpoint.basePath)\(endpoint.path)"
        }
        components?.queryItems = endpoint.urlQueries?.asURLQueryItemArray()
        
        guard let url = components?.url else {
            throw RemoteError.badURL
        }
        
        var httpHeaders = endpoint.httpHeaders
        if endpoint.requiresAuthorization {
            guard let authorizationHeader else {
                throw RemoteError.authorizationRequired
            }

            httpHeaders.update(with: .authorization(authorizationHeader))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.allHTTPHeaderFields = httpHeaders.asDictionary()
        let body = try endpoint.body
        request.httpBody = body
        request.allHTTPHeaderFields?["Content-Length"] = body?.count.description
        
        self = request
    }
}
