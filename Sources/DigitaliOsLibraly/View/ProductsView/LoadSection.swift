//
//  LoadSection.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 17.04.2022.
//

import SwiftUI

struct LoadSection: View {
    @StateObject var products: Load<Product>
    @State var loading: Bool = true
    @Binding var productShowView: ProductShowView
    var body: some View {
        
        ZStack {
            ProductsView(products: products,
                         productShowView: $productShowView)
            if loading == true {
                SectionAnimationLoad()
                    .padding(.horizontal, 40.0)
                
                    .background()
                    .onAppear {
                        products.get() {
                            loading = false
                        }
                    }
                
            }
        }
          
    }
}

struct LoadSection_Previews: PreviewProvider {
    var products: Load<Product>
    @State var productShowView: ProductShowView = .none
    
    init() {
        self.products = Load<Product>()
        var sectionProduct = Product()
        sectionProduct.value["type_id"] = "section"
        products.elements.append(Product())
        products.elements.append(sectionProduct)
        products.elements.append(sectionProduct)
        products.elements.append(Product())
        products.elements.append(Product())
        products.elements.append(sectionProduct)
        products.elements.append(Product())
    }
    static var previews: some View {
        LoadSection(products: Self().products,
                    productShowView: Self().$productShowView)
    }
}
