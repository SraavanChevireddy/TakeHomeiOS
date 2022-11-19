//
//  ConverterView.swift
//  TakeHomeTestiOS
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import SwiftUI
import CurrencyConverter

struct ConverterView: View {
    @StateObject var model: CurrencyViewModel
    @Binding var navigationSelection: CurrencyType?
    
    var body: some View {
        ScrollView(.vertical) {
            if model.appState == .loading {
                ProgressView("Loading")
            } else {
                VStack(spacing: 16) {
                    if let currencies = model.datastore.currencies, let rates = currencies.rates {
                        Menu  {
                            ForEach(rates.keys.sorted(), id: \.self){ eachKey in
                                Button {
                                    model.datastore.fromCurrency = eachKey
                                } label: {
                                    Text("\(eachKey) - \(rates[eachKey] ?? 0, specifier: "%.2f")")
                                }
                                
                            }
                        } label: {
                            Label("\(currencies.base ?? "") - \(rates[currencies.base ?? ""] ?? 0.0, specifier: "%.2f")", systemImage: "hand.tap.fill")
                                .tint(.indigo)
                            
                        }
                        
                        TextField("Amount", text: $model.datastore.userInput, prompt: Text("Enter the Amount"))
                            .font(.system(.title3, design: .rounded, weight: .semibold))
                            .foregroundColor(.indigo)
                            .keyboardType(.numberPad)
                        
                        Menu  {
                            ForEach(rates.keys.sorted(), id: \.self){ eachKey in
                                Button {
                                    model.datastore.toCurrency = eachKey
                                } label: {
                                    Text("\(eachKey)")
                                }
                            }
                        } label: {
                            Text("\(model.datastore.toCurrency.isEmpty ? "Choose Currency to Convert" : model.datastore.toCurrency)")
                                .foregroundColor(.white)
                                .font(.system(.title3, design: .rounded, weight: .bold))
                                .padding()
                                .background(Color.indigo)
                                .clipShape(Capsule())
                        }
                        
                    }
                    Button {
                        model.convertCurrency()
                    } label: {
                        Text("Convert")
                    }.tint(.indigo)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    
                    if let conversion = model.result {
                        Text("Your currency in \(model.datastore.toCurrency)")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .rounded))
                            .bold()
                            .textCase(.uppercase)
                        
                        Label("\(conversion)", systemImage: model.userGettingMoreCurrency ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                            .foregroundColor(model.userGettingMoreCurrency ? Color.green : Color.red)
                            .font(.system(.largeTitle, design: .rounded))
                            .bold()
                            .tint(model.userGettingMoreCurrency ? Color.green : Color.red)
                    } else {
                        Text("Unknown error occured.")
                            .foregroundColor(.red)
                            .font(.system(.largeTitle, design: .rounded))
                            .bold()
                    }
                }.padding()
            }
        }.frame(maxWidth: .infinity)
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
