//
//  File.swift
//  
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import Foundation
import Combine

public enum CurrencyType : Hashable{
    case historical
    case latest
}

final public class CurrencyDataStore: ObservableObject {
    
    var currencyType: CurrencyType = .latest
    
    @Published public var currencies: CurrenciesDTO!
    @Published public var historicalCurrencies: [CurrenciesDTO] = []
    
    @Published public var multiplier : Double = 1.0
    @Published public var result: Double = 1.0
    
    @Published public var fromCurrency: String!
    @Published public var toCurrency = ""
    @Published public var currencyError: CurrencyErrors!
    
    @Published public var inputCurrency: String = "1.0" {
        didSet {
            if let value = Double(inputCurrency) {
                input = value
            }
        }
    }
    
    private var input: Double!
    
    func getPast(dates from: Date = Date(), past for: Int = 3) -> [String] {
        var currentDate = from
        var pastThreeDates: [String] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for _ in 1...`for`{
            if let date = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) {
                currentDate = date
                pastThreeDates.append(dateFormatter.string(from: currentDate))
            }
        }
        return pastThreeDates
    }
    
    public func calculateResult() throws -> Double {
        if let currency = currencies, let currencyRate = currency.rates, let currencyValue = currencyRate[toCurrency] {
            currencyError = nil
            
            multiplier = currencyValue
            return input * currencyValue
        } else if toCurrency.isEmpty || fromCurrency.isEmpty || input == nil {
            currencyError = CurrencyErrors.invalidInput
            throw currencyError
        } else {
            currencyError = CurrencyErrors.currencyNotFound
            throw currencyError
        }
    }
}
