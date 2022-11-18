//
//  CurrenciesDTO.swift
//
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import Foundation

struct CurrenciesDTO: Decodable {
    let success: Bool?
    let timestamp: Int?
    let base, date: String?
    let rates: [String: Double]?
    
    /// `historical` is an optional key. Can be decoded only while fetching the historical data.
    var historical: Bool?
}
