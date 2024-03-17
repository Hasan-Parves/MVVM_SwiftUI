//
//  WorldofPaybackBackendJSONDecoder.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

public final class WorldofPaybackBackendJSONDecoder: JSONDecoder {
    override public init() {
        super.init()
        dateDecodingStrategy = .wPaybackBackend
    }
}
