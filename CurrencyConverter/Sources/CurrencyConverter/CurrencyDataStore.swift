//
//  File.swift
//  
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import Foundation
import Combine

public enum CurrencyType {
    case historical
    case latest
}

final public class CurrencyDataStore: ObservableObject {
    
    var currencyType: CurrencyType = .latest
    
    @Published var currencies: CurrenciesDTO!
    @Published var historicalCurrencies: [CurrenciesDTO] = []
    
    func getPast(dates from: Date = Date(), past for: Int = 3) -> [String]{
        var currentDate = from
        var pastThreeDates: [String] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for _ in 1...`for`{
            if let date = Calendar.current.date(byAdding: .day, value: -1, to: currentDate){
                currentDate = date
                pastThreeDates.append(dateFormatter.string(from: currentDate))
            }
        }
        return pastThreeDates
    }
}
