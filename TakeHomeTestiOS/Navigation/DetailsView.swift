//
//  DetailsView.swift
//  TakeHomeTestiOS
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import SwiftUI
import CurrencyConverter

struct DetailsView: View {
    /// This value is a binding, and the superview must pass in its value.
    @Binding var selection: SelectionType?
    /// The app's model the superview must pass in.
    
    @ObservedObject var model: CurrencyViewModel
    var body: some View {
        switch selection ?? .latest {
        case .latest:
            ConverterView(model: model, navigationSelection: $selection)
        case .historicalData:
            HistoricalDataView()
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(selection: .constant(.latest), model: CurrencyViewModel())
    }
}
