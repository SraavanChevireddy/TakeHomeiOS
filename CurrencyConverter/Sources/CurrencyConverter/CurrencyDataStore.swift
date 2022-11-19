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
    var baseCurrency: String!
    
    @Published public var currencies: CurrenciesDTO!
    @Published public var historicalCurrencies: [CurrenciesDTO] = []
    
    @Published public var fromCurrency = "EUR"
    @Published public var toCurrency = ""
    @Published public var currencyError: CurrencyErrors!
    
    @Published public var userInput: String = "0.0"{
        didSet {
            if let value = Double(userInput){
                input = value
            }
        }
    }
    
    public var input: Double = 0.0
    
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
        if let currency = currencies, let currencyRate = currency.rates, let payRate = currencyRate[toCurrency] {
            if let basePay = baseCurrency, let basePayRate = currencyRate[basePay] {
                return (input/payRate) * basePayRate
            } else {
                currencyError = CurrencyErrors.invalidInput
                throw currencyError
            }
        } else if toCurrency.isEmpty || fromCurrency.isEmpty || Double(userInput) == nil {
            currencyError = CurrencyErrors.invalidInput
            throw currencyError
        } else {
            currencyError = CurrencyErrors.currencyNotFound
            throw currencyError
        }
    }
}
