//
//  PopularCurrenciesView.swift
//  TakeHomeTestiOS
//
//  Created by Sraavan Chevireddy on 11/22/22.
//

import SwiftUI
import CurrencyConverter

struct PopularCurrenciesView: View {
    @StateObject var model: CurrencyViewModel
    
    var body: some View {
        VStack{
            Text("Coming Soon")
                .font(.system(.title3, design: .rounded, weight: .bold))
                
            Text("We are actively working on giving you a better experience")
                .foregroundColor(.secondary)
        }
            .navigationTitle("Popular")
    }
}

struct PopularCurrenciesView_Previews: PreviewProvider {
    static var previews: some View {
        PopularCurrenciesView(model: CurrencyViewModel())
    }
}
