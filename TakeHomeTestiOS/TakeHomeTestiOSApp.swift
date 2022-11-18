//
//  TakeHomeTestiOSApp.swift
//  TakeHomeTestiOS
//
//  Created by Sraavan Chevireddy on 11/18/22.
//

import SwiftUI
import CurrencyConverter
@main
struct TakeHomeTestiOSApp: App {
    @StateObject private var conveter = CurrencyViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(model: conveter)
        }
        #if os(macOS)
        .defaultSize(width: 1000, height: 650)
        #endif
        
        #if os(macOS)
        MenuBarExtra {
            ScrollView {
                VStack(spacing: 0) {
                    Text("Conveter")
                }
            }
        } label: {
            Label("Converter", systemImage: "coloncurrencysign.circle.fill")
        }
        .menuBarExtraStyle(.window)
        #endif
    }
}
