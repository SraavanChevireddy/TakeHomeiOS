//
//  ConverterView.swift
//  TakeHomeTestiOS
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import SwiftUI
import CurrencyConverter

struct ConverterView: View {
    @ObservedObject var model: CurrencyViewModel
    @Binding var navigationSelection: CurrencyType?
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {
                Image("Banner")
                    .resizable()
                    .frame(height: 200)
                
                Menu  {
                    if let currencies = model.datastore.currencies, let rates = currencies.rates {
                        ForEach(rates.keys.sorted(), id: \.self){ eachKey in
                            Text("\(eachKey) - \(rates[eachKey] ?? 0)")
                        }
                    }
                } label: {
                    Text("\(model.datastore.fromCurrency ?? "")")
                }
                
                TextField("Currency Input", text: $model.datastore.inputCurrency, prompt: Text("Enter your Currency Value"))
                    .keyboardType(.numberPad)
                
                Menu  {
                    if let currencies = model.datastore.currencies, let rates = currencies.rates {
                        ForEach(rates.keys.sorted(), id: \.self){ eachKey in
                            Button {
                                model.datastore.toCurrency = eachKey
                            } label: {
                                Text("\(eachKey)")
                            }
                        }
                    }
                } label: {
                    Text("\(model.datastore.toCurrency)")
                }

                if let result = try? model.datastore.calculateResult() {
                    Text("Your currency in \(model.datastore.toCurrency)")
                        .foregroundColor(.secondary)
                        .font(.system(.body, design: .rounded))
                        .bold()
                        .textCase(.uppercase)
                    
                    Text("\(result)")
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                } else {
                    Text("Unknown error occured.")
                        .foregroundColor(.red)
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                }
            }
        }.ignoresSafeArea(.all)
#if os(iOS)
            .background(Color(uiColor: .systemGroupedBackground))
#else
            .background(.quaternary.opacity(0.5))
#endif
            .background()
            .navigationTitle("Converter")
    }
}

struct ConverterView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: CurrencyViewModel(), navigationSelection: .constant(.latest))
    }
}
