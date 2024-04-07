//
//  LoadListView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 25.04.2022.
//

import SwiftUI

struct LoadListView: View {
    @StateObject var shoppingCart: Load<ShoppingCart> = .init("/api/renewWishlist/")
    @State var loading: Bool = true
    @State var listEmpty: Bool = false
    
    var body: some View {
        ZStack {
            
            
                
            
            if loading == true {
                ShoppingCartAnimationLoad()
                    .background()
                    .onAppear {
                        shoppingCart.get() {
                            if shoppingCart.elements.count == 0 {
                                listEmpty = true
                            }
                            loading = false
                        }
                    }
                
            } else {
                ListView(shoppingCart: shoppingCart)
            }
            
            if listEmpty {
                let listEmpty = lang["yourWishListEmpty"] ?? "Your wish list is still empty"
                VStack {
                    Spacer()
                    Image("shoppingCartEmpty")
                        .resizable()
                        .frame(width: 150, height: 200)
                    Text(listEmpty)
                        .padding(.horizontal)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundSection)
            }
            
        }
    }
}

struct LoadListView_Previews: PreviewProvider {
    static var previews: some View {
        LoadListView()
    }
}
