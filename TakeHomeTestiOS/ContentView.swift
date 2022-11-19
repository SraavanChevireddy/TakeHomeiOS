//
//  ContentView.swift
//  TakeHomeTestiOS
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import SwiftUI
import CurrencyConverter

struct ContentView: View {
    @ObservedObject var model : CurrencyViewModel
    
    @State private var selection: CurrencyType? = CurrencyType.latest
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationSplitView {
            SideMenu(selection: $selection)
        } detail: {
            NavigationStack(path: $path) {
                DetailsView(selection: $selection, model: model)
            }
        }
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 450)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: CurrencyViewModel())
    }
}
