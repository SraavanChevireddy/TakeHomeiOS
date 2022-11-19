//
//  File 2.swift
//
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import Foundation

let currencyDomain = "https://api.apilayer.com/"

enum Endpoints: String {
    case fetchAllCurrencies = "fixer/latest"
    case fetchHistorical = "fixer"
}

public enum CurrencyErrors: Error {
    case currencyNotFound
    case invalidInput
}

