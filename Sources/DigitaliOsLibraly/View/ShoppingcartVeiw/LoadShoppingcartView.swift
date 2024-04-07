//
//  LoadShoppingcartView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 25.04.2022.
//

import SwiftUI

struct LoadShoppingcartView: View {
    
    @StateObject var shoppingCart: Load<ShoppingCart> = .init("/api/renewShoppingCart/")
    @State var loading: Bool = true
    @State var shoppingCartEmpty: Bool = false
    
    var body: some View {
        ZStack {
            
            if loading == true {
                ShoppingCartAnimationLoad()
                    .background()
                    .onAppear {
                        shoppingCart.get() {
                            if shoppingCart.elements.count == 0 {
                                shoppingCartEmpty = true
                            }
                            loading = false
                        }
                    }
                
            } else {
                if shoppingCartEmpty {
                    VStack {
                        Spacer()
                        Image("shoppingCartEmpty")
                            .resizable()
                            .frame(width: 150, height: 200)
                        let shoppingCartEmpty = lang["shoppingCartIsEmpty"] ?? "Your shopping cart is still empty!"
                        Text(shoppingCartEmpty)
                            .padding(.horizontal)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.backgroundSection)
                } else {
                    ShoppingcartView(shoppingCart: shoppingCart)
                }
            }
            
        }
    }
}

struct LoadShoppingcartView_Previews: PreviewProvider {
    static var previews: some View {
        LoadShoppingcartView()
    }
}
