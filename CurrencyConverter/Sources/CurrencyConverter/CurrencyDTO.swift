//
//  CurrenciesDTO.swift
//
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import Foundation

public struct CurrenciesDTO: Decodable {
    public var success: Bool?
    public var timestamp: Int?
    public var base, date: String?
    public var rates: [String: Double]?
    
    /// `historical` is an optional key. Can be decoded only while fetching the historical data.
    public var historical: Bool?
}
