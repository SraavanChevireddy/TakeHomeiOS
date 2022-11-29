import Combine
import XCTest
@testable import CurrencyConverter

final class CurrencyConverterTests: XCTestCase {
    private var currencyViewModel: CurrencyViewModel?
    private var expectation: XCTestExpectation?
    private var disposables: Set<AnyCancellable>?
    
    @MainActor override func setUpWithError() throws {
        currencyViewModel = CurrencyViewModel()
        disposables = Set()
        expectation = XCTestExpectation(description: "ExpectingTheNetworkCall")
    }
    
    override func tearDownWithError() throws {
        currencyViewModel = nil
        expectation = nil
    }
    
    @MainActor
    func testNetworking() throws {
        let endPointType = Endpoints.fetchAllCurrencies.rawValue
        guard let url = URL(string: currencyDomain + endPointType) else {
            return
        }
        Task(priority: .background) {
            if let currencyViewModel = currencyViewModel {
                try? await currencyViewModel.fetchCurrencies(for: currencyViewModel.generateRequest(from: url))
                    .sink(receiveCompletion: { result in
                        switch result {
                        case .failure(let err):
                            XCTAssertTrue(false, "Error: \(err.localizedDescription)")
                        case .finished:
                            XCTAssertTrue(true, "Currency response received")
                        }
                    }, receiveValue: { [weak self] response in
                        guard let self = self else {
                            return
                        }
                        self.currencyViewModel?.datastore.fromCurrency = response.base ?? ""
                        self.currencyViewModel?.datastore.baseCurrency = response.base ?? ""
                        self.currencyViewModel?.datastore.currencies = response
                        self.expectation?.fulfill()
                    }).store(in: &self.disposables!)
                
                if let expectation = expectation {
                    wait(for: [expectation], timeout: 7)
                }
            }
        }
    }
    
    
}
