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
    
    var body: some View {
        Text("Historical Data View")
    }
}

struct HistoricalDataView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricalDataView(model: CurrencyViewModel())
    }
}
