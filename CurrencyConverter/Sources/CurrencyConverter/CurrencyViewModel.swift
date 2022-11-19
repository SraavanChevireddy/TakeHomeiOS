//
//  CurrencyViewModel.swift
//
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import Foundation
import Combine

@MainActor
public class CurrencyViewModel: ObservableObject {
    
    public var datastore: CurrencyDataStore!
    private var disposables = Set<AnyCancellable>()
    
    @Published public var appState = AppState.idle
    @Published public var result: Double = 0.0
    
    public init(){
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        datastore = CurrencyDataStore()
        Task(priority: .high) {
            appState = .loading
            try? await fetch(currencies: .latest)
            try? await fetch(currencies: .historical, forPast: 3)
        }
    }
    
    private func fetch(currencies currencyType: CurrencyType = .latest, forPast:Int? = nil) async throws {
        var endPointType: String!
        
        switch currencyType{
        case .historical:
            endPointType = Endpoints.fetchHistorical.rawValue
            datastore.historicalCurrencies.removeAll()
            
            for eachDate in datastore.getPast(past: forPast ?? 0) {
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
                        eachCurrency.sink { [unowned self] result in
                            switch result {
                            case .failure(let err):
                                debugPrint(err.localizedDescription)
                                appState = .error
                            case .finished: debugPrint("response received")
                            }
                        } receiveValue: { [unowned self] historicalData in
                            objectWillChange.send()
                            datastore.historicalCurrencies.append(historicalData)
                            appState = .idle
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
                .sink(receiveCompletion: { [weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .failure(let err):
                        debugPrint(err.localizedDescription)
                        self.appState = .error
                    case .finished: debugPrint("response received")
                    }
                }, receiveValue: { [weak self] latestCurrency in
                    guard let self = self else {return}
                    self.objectWillChange.send()
                    self.datastore.fromCurrency = latestCurrency.base ?? ""
                    self.datastore.baseCurrency = latestCurrency.base ?? ""
                    self.datastore.currencies = latestCurrency
                    self.appState = .idle
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

    // MARK: Currency
    
    public var userGettingMoreCurrency: Bool {
        result > datastore.input
    }
    public func convertCurrency() {
        do {
            result = try datastore.calculateResult()
            groupCurrencyById()
        } catch {
            debugPrint(error.localizedDescription)
            appState = .error
        }
    }

    public func groupCurrencyById() {
        var groupedResult: Dictionary<String, Double> = [:]
        datastore.historicalCurrencies.forEach { eachYear in
            if let currency = eachYear.rates {
                groupedResult.merge(zip(currency.keys, currency.values)) { currentValue, newValue in
                    currentValue
                }
            }
        }
        print("HEHE \(groupedResult)")
    }
}

