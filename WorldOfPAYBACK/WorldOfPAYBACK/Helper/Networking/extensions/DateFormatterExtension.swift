//
//  DateFormatterExtension.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//

import Foundation

/// DateFormatters for communication with our backend
public extension DateFormatter {
    enum Backend {
        public static let basic: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
            return dateFormatter
        }()
        
        public static let withoutMS: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
            return dateFormatter
        }()
        
        public static let withTimeZone: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            return dateFormatter
        }()
    
        public static let dateOnly: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter
        }()
    
        public static let iso8601 = ISO8601DateFormatter()
    }
}
