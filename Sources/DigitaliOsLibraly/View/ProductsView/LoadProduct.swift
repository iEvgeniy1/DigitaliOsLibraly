//
//  LoadProduct.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 15.04.2022.
//

import SwiftUI
import Dispatch

struct LoadProduct: View {
    @StateObject var product: Load<Product>
    @State var loading: Bool = true

    var body: some View {
        
        ZStack {
            ProductView(product: product)
            if loading == true {
                ProductAnimationLoad()
                    .background()
                    .onAppear {
                        product.get() {
                            loading = false
                        }
                    }
                
            }
        }
          
    }
    
}

struct LoadProduct_Previews: PreviewProvider {
    var product = Load<Product>()
    init() {
        product.value = Product()
    }
    static var previews: some View {
        LoadProduct(product: Self().product)
    }
}
