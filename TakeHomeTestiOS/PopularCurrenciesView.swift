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
        Text("Hello, World!")
            .navigationTitle("Popular")
    }
}

struct PopularCurrenciesView_Previews: PreviewProvider {
    static var previews: some View {
        PopularCurrenciesView(model: CurrencyViewModel())
    }
}
