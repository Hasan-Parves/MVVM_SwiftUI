//
//  JSONDateDecodingStrategyExtension.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    static let wPaybackBackend = custom { decoder -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        if let date = DateFormatter.Backend.basic.date(from: dateString) {
            return date
        } else if let date = DateFormatter.Backend.withoutMS.date(from: dateString) {
            return date
        } else if let date = DateFormatter.Backend.withTimeZone.date(from: dateString) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateString)")
    }
}
