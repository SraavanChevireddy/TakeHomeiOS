//
//  SideMenu.swift
//  TakeHomeTestiOS
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import SwiftUI
import CurrencyConverter


struct SideMenu: View {
    @Binding var selection: CurrencyType?
    var body: some View {
        List(selection: $selection) {
            NavigationLink(value: CurrencyType.latest) {
                Label("Converter", systemImage: "box.truck")
            }
            
            NavigationLink(value: CurrencyType.historical) {
                Label("Historical Data", systemImage: "clock.fill")
            }
            
            NavigationLink(value: CurrencyType.popular) {
                Label("Popular", systemImage: "star.fill")
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
