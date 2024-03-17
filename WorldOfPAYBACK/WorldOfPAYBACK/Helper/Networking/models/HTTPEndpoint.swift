//
//  HTTPEndpoint.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

public protocol HTTPEndpoint {
    associatedtype Validator: URLResponseValidator
    associatedtype Decoder: ResponseDecoder
    
    typealias HTTPHeaders = Set<HTTPHeader>
    typealias URLQueries = [URLQuery]?
    
    var scheme: String { get }
    var basePath: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var urlQueries: URLQueries { get }
    var httpHeaders: HTTPHeaders { get }
    var body: Data? { get throws }
    var requiresAuthorization: Bool { get }
    var validator: Validator { get }
    var decoder: Decoder { get }
    static var logger: Logger? { get }
}

// Default values, if nothing else is provided by the specific HTTPEndpoint implementation
public extension HTTPEndpoint {
    var scheme: String {
        "https://"
    }
    
    var basePath: String {
        let useTestData = Bundle.main.object(forInfoDictionaryKey: "USE_TEST_DATA") as! Bool
        if useTestData {
            return testBasePath
        } else {
            return "api.payback.com/"
        }
    }
    
    var testBasePath: String {
        "api-test.payback.com/"
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var urlQueries: URLQueries {
        nil
    }
    
    var httpHeaders: HTTPHeaders {
        [.accept([.json]), .acceptLanguage]
    }
    
    var body: Data? {
        nil
    }
    
    var requiresAuthorization: Bool {
        false
    }
    
    var validator: HTTPURLResponseValidator {
        HTTPURLResponseValidator()
    }
    
    var decoder: EmptyResponseDecoder {
        EmptyResponseDecoder()
    }
    
    static var logger: Logger? {
        nil
    }
}
