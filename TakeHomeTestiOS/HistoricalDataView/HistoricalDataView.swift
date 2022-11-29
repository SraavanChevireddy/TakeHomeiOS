//
//  HistoricalDataView.swift
//  TakeHomeTestiOS
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import SwiftUI
import Charts
import CurrencyConverter

struct HistoricalDataView: View {
    @StateObject var model : CurrencyViewModel
    @State private var selectedCountryCode: String = "EUR"
    
    var body: some View {
        Form {
            Section{
                Picker(selection: $selectedCountryCode) {
                    if let currencies = model.datastore.currencies, let rates = currencies.rates {
                        ForEach(rates.keys.sorted(), id: \.self){ eachKey in
                            Text(eachKey)
                        }
                    }
                } label: {
                    Text("Select your Country")
                }
#if os(iOS)
                .pickerStyle(.navigationLink)
#endif
            }
            
            Section {
                Button(role: .destructive) {
                    debugPrint("SignOut")
                } label: {
                    Text("Sign out")
                }

            }
        }
    }
}

struct HistoricalDataView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricalDataView(model: CurrencyViewModel())
    }
}
