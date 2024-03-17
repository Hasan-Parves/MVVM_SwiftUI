//
//  ResponseDecoder.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

public protocol ResponseDecoder {
    associatedtype ResultType
    
    func decode(data: Data) throws -> ResultType
}

public struct JSONResponseDecoder<ResultType: Decodable>: ResponseDecoder {
    private let decoder: JSONDecoder
    
    public init(decoder: JSONDecoder = WorldofPaybackBackendJSONDecoder()) {
        self.decoder = decoder
    }
    
    public func decode(data: Data) throws -> ResultType {
        try decoder.decode(ResultType.self, from: data)
    }
}

public struct EmptyResponseDecoder: ResponseDecoder {
    public init() {}
    
    public func decode(data: Data) throws {
        if !data.isEmpty {
            throw RemoteError.invalidData
        }
    }
}
