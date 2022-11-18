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
    @Binding var navigationSelection: SelectionType?
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
#endif
    
    var body: some View {
        WidthThresholdReader(widthThreshold: 520) { proxy in
            ScrollView(.vertical){
                VStack(spacing: 16) {
                    Image("Banner")
                        .resizable()
                        .frame(height: 200)
                    Text("ASdsadasdasdas")
//                    ForEach(model.datastore.currencies, id: \.self) { eachCurrency in
//                        Text(eachCurrency)
//                    }
                }
            }.ignoresSafeArea(.all)
        }
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
