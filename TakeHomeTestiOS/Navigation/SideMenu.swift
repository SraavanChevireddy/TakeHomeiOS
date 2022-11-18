//
//  SideMenu.swift
//  TakeHomeTestiOS
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import SwiftUI
import CurrencyConverter

/// An enum that represents the currency's selection in the app's sidebar.
enum SelectionType: Hashable {
    case latest
    case historicalData
}

struct SideMenu: View {
    @Binding var selection: SelectionType?
    var body: some View {
        List(selection: $selection) {
            NavigationLink(value: SelectionType.latest) {
                Label("Converter", systemImage: "box.truck")
            }
            
            NavigationLink(value: SelectionType.historicalData) {
                Label("Historical Data", systemImage: "shippingbox")
            }
        }
        .navigationTitle("Currency Conveter")
        #if os(macOS)
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
        #endif
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenu(selection: .constant(.latest))
    }
}
