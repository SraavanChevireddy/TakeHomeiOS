//
//  File.swift
//  
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import Foundation
import Combine

class CurrencyViewModel: ObservableObject {

    private var disposables = Set<AnyCancellable>()
    
    public init(){
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        Task(priority: .high) {
            try? await fetchCurrencies()
        }
        
    }
    
    private func fetchCurrencies() async throws {
        guard let url = URL(string: currencyDomain + Endpoints.fetchAllCurrencies.rawValue) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("SizA2Lf7p0YHqmDi9BdOz2Wv7l4qsDlN", forHTTPHeaderField: "apikey")
        
        URLSession.shared.dataTask(with: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: CurrenciesDTO.self, decoder: JSONDecoder())
            .receive(on: .main)
            .sink { result in
                guard case .failure(let err) = result else {
                    return
                }
            } receiveValue: { currencies in
                print(currencies)
            }
    }
    
    
    
    
}
