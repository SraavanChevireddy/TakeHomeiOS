//
//  File 3.swift
//  
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import Foundation

struct CurrenciesDTO: Decodable {
    let success: Bool
    let timestamp: Int
    let base, date: String
    let rates: [String: Double]
}
