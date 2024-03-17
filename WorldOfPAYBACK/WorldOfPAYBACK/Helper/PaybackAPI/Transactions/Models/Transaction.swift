//
//  Transaction.swift
//  WorldOfPAYBACK
//
//  Created by Hasan Parves on 30.01.24.
//
import Foundation

struct TransactionResponse: Codable {
    let items: [Transaction]
}

struct Transaction: Codable, Identifiable, Equatable {
    var id: Int {
        return Int(alias.reference) ?? 0
    }
    
    let partnerDisplayName: String
    let alias: Alias
    let category: Int
    let transactionDetail: TransactionDetail
    var bookingDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case partnerDisplayName, alias, category, transactionDetail, bookingDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode other properties
        partnerDisplayName = try container.decode(String.self, forKey: .partnerDisplayName)
        alias = try container.decode(Alias.self, forKey: .alias)
        category = try container.decode(Int.self, forKey: .category)
        transactionDetail = try container.decode(TransactionDetail.self, forKey: .transactionDetail)
        
        //set booking time from ISO8601DateFormatter
        let strategy = Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))", timeZone: .current)
        
        if let date = try? Date(transactionDetail.bookingDate, strategy: strategy) {
            bookingDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .bookingDate, in: container, debugDescription: "Invalid date format")
        }
    }
    
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Alias: Codable {
    let reference: String
}

struct TransactionDetail: Codable {
    let description: String?
    let bookingDate: String
    let value: Value
}

struct Value: Codable {
    let amount: Int
    let currency: String
}

extension Date {
    func toDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
