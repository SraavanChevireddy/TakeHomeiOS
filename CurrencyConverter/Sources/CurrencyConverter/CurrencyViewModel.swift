//
//  CurrencyViewModel.swift
//
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import Foundation
import Combine

public class CurrencyViewModel: ObservableObject {
    
    private var datastore: CurrencyDataStore!
    private var disposables = Set<AnyCancellable>()
    
    public init(){
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        datastore = CurrencyDataStore()
        Task(priority: .high) {
            try? await fetch(currencies: .historical)
        }
    }
    
    private func fetch(currencies currencyType: CurrencyType = .latest) async throws {
        var endPointType: String!
        
        switch currencyType{
        case .historical:
            endPointType = Endpoints.fetchHistorical.rawValue
            datastore.historicalCurrencies.removeAll()
            
            for eachDate in datastore.getPast() {
                guard let url = URL(string: currencyDomain + endPointType + "/\(eachDate)") else {
                    return
                }
                try? await withThrowingTaskGroup(of: AnyPublisher<CurrenciesDTO, Error>.self) { group in
                    
                    group.addTask {
                        var request = URLRequest(url: url)
                        request.httpMethod = "GET"
                        request.setValue("SizA2Lf7p0YHqmDi9BdOz2Wv7l4qsDlN", forHTTPHeaderField: "apikey")
                        return try await self.fetchCurrencies(for: request)
                    }
                    
                    for try await eachCurrency in group{
                        eachCurrency.sink { result in
                            switch result {
                            case .failure(let err):
                                debugPrint(err.localizedDescription)
                            case .finished: debugPrint("response received")
                            }
                        } receiveValue: { [unowned self] historicalData in
                            print("ZING!!")
                            datastore.historicalCurrencies.append(historicalData)
                        }.store(in: &disposables)
                    }
                }
            }
        case .latest:
            endPointType = Endpoints.fetchAllCurrencies.rawValue
            guard let url = URL(string: currencyDomain + endPointType) else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("SizA2Lf7p0YHqmDi9BdOz2Wv7l4qsDlN", forHTTPHeaderField: "apikey")
            
            try? await fetchCurrencies(for: request)
                .sink(receiveCompletion: { result in
                    switch result {
                    case .failure(let err):
                        debugPrint(err.localizedDescription)
                    case .finished: debugPrint("response received")
                    }
                }, receiveValue: { [unowned self] latestCurrency in
                    datastore.currencies = latestCurrency
                }).store(in: &disposables)
        }
    }
    
    private func fetchCurrencies(for request: URLRequest) async throws  -> AnyPublisher<CurrenciesDTO, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: CurrenciesDTO.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

