//
//  Logger.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

public protocol Logger {
    func log(message: String, type: LogType)
    func log(request: URLRequest)
    func log(response: URLResponse)
    func log(data: Data)
    func log<T>(result: T, for request: URLRequest)
    func log<T: HTTPEndpoint>(error: Error, for endpoint: T)
}

public extension Logger {
    func log(request: URLRequest) {
        log(message: "Requesting \(request.httpMethod ?? "") \(request) ...\n", type: .basic)
        log(message: "Sent headers:\n\(description(for: request.allHTTPHeaderFields))", type: .headers)
        if let body = request.httpBody {
            log(message: "Sent body:\n\(body)\n", type: .verbose)
            if let bodyString = String(data: body, encoding: .utf8) {
                log(message: bodyString, type: .verbose)
            }
        }
    }
    
    func log(response: URLResponse) {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        let statusCode = httpResponse.statusCode
        let url = String(describing: response.url)
        log(message: "Received response (Status Code: \(statusCode) for request to \(url)\n", type: .basic)
        log(message: "Response headers:\n\(description(for: httpResponse.allHeaderFields))", type: .headers)
    }
    
    func log(data: Data) {
        log(message: "Received data (\(data.count) Bytes)", type: .verbose)
        
        if let dataString = String(data: data, encoding: .utf8) {
            log(message: "\(dataString)\n", type: .verbose)
        }
    }
    
    func log<T>(result: T, for request: URLRequest) {
        log(message: "Decoding for request to \(request) was successful", type: .basic)
        log(message: "The result is:\n\(result)\n", type: .verbose)
    }
    
    func log(error: Error, for endpoint: some HTTPEndpoint) {
        log(message: "Request to \(endpoint.basePath)\(endpoint.path) failed:\n\(error)", type: .error)
    }
    
    private func description(for allHeaderFields: [AnyHashable: Any]) -> String {
        allHeaderFields.reduce(into: "") {
            $0 += "\t" + String(describing: $1.key) + ": " + String(describing: $1.value) + "\n"
        }
    }
    
    private func description(for allHeaderFields: [String: String]?) -> String {
        guard let allHeaderFields else { return "[]" }
        
        return allHeaderFields.reduce(into: "") {
            $0 += "\t" + $1.key + ": " + $1.value + "\n"
        }
    }
}
