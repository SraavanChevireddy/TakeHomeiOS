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
    case popular
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
                return calculateConversion(on: input, payrate: payRate, basePayRate)
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
    
    /// To return the historical data of the currency for past three dates.
    /// - Parameter byKey: Country code for historical information
    /// - Returns: The array of past values that the currency holds for the available dates.
    public func historicalConversion(byKey: String) -> [Double] {
        var pastCurrency: [Double] = []
        historicalCurrencies.forEach { eachDTO in
            if let rates = eachDTO.rates {
                pastCurrency.append(rates[byKey] ?? 0.0)
            }
        }
        return pastCurrency
    }
    
    /// To convert the currency from one currency to another.
    ///
    /// - Parameters:
    ///   - input: The currency amount you wanted to convert
    ///   - payrate: The base payrate of the currency you wanted to convert against. In this case base is `EUR`.
    ///   - basePayRate: The base payrate is the currency value that is received from the `APILayer`
    /// - Returns: The converted currency value from after the conversion.
    func calculateConversion(on input: Double, payrate: Double, _ basePayRate: Double) -> Double {
        (input/payrate) * basePayRate
    }
    
}
