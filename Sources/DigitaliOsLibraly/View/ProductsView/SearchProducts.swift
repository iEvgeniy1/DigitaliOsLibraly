//
//  SearchProducts.swift.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 27.04.2022.
//

import SwiftUI

struct SearchProducts: View {
    @Binding var productShowView: ProductShowView
    @State var search: String = ""
    
    var body: some View {
        VStack(spacing: 1) {
            let searchText = lang["search"] ?? "Search"
            HStack {
                TextField(searchText, text: self.$search)
                
                Spacer()
                Button(action: {
                    self.productShowView = .section(pathUrl: "/api/search?searchedName=" + search, header: search)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showProductView"), object: nil)
                    UIApplication.shared.endEditing()
                }) {
                    let saveText = lang["find"] ?? "Find"
                    let size = saveText.widthOfString(usingFont: UIFont.systemFont(ofSize: 20, weight: .regular))
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .foregroundColor(.textDarkWhiteSet)
                        
                        Text(saveText)
                            .foregroundColor(Color.textWhiteDarkSet)
                    }
                    .padding(.trailing, -13.0)
                    .frame(width: size+4, height: 35)
                }
            }
            .modifier(TextFieldModifier())
            .cornerRadius(10)
        }
    }
}

struct SearchProducts_Previews: PreviewProvider {
    @State var productShowView: ProductShowView = .none
    static var previews: some View {
        SearchProducts(productShowView: Self().$productShowView)
    }
}
