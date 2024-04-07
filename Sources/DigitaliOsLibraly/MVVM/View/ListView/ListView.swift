//
//  ListView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 26.03.2022.
//

import SwiftUI

struct ListView: View {
    @StateObject var shoppingCart: Load<ShoppingCart>
    @State var heartIcon: [String] = []
    @State var showProduct: Bool = false
    @State var productView: AnyView = AnyView(EmptyView())
    @State var offsetX: CGFloat = 0

    var testView: Bool = false
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 10) {
                
                let wishlist = lang["lists"] ?? "Lists"
                Text(wishlist)
                
                ScrollView {
                    ForEach(0..<self.heartIcon.count, id: \.self) { i in
                        let product = self.shoppingCart.elements[i]
                        
                        HStack(spacing: 10) {
                            
                            ImageLoad(nameImage: product.photo,
                                      width: 75,
                                      height: 75)
                                .cornerRadius(10)
                                .frame(height: 75)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Button(action: {
                                    productView = AnyView(LoadProduct(product: Load<Product>("/api/p/\(product.url)/")))
                                    showProduct.toggle()
                                }) {
                                    Text(product.h1)
                                        .font(.headline)
                                        .foregroundColor(.textDarkWhiteSet)
                                        .multilineTextAlignment(.leading)
                                }
                                
                                let priceWithCarancy = product.price == 0 ? "" : String(product.price) + " " + (lang["currency"] ?? "$")
                                Text(priceWithCarancy)
                                    .foregroundColor(Color.cyan)
                                    .font(.footnote)
                                
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                let addOrDelete = heartIcon[i] == "heart" ? "addToWishlist/\(product.productId)/1/" : "deleteFromWishlist/\(product.productId)/"
                                let shoppingCart = Load<Product>("/api/" + addOrDelete)
                                shoppingCart.get() {
                                    DispatchQueue.main.async {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "needRenewWishlist"), object: nil)
                                    }
                                }
                                heartIcon[i] = heartIcon[i] == "heart" ? "heart.fill" : "heart"
                            }) {
                                Image(systemName: heartIcon[i])
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 25, height: 24)
                                    .padding(.trailing, 15.0)
                            }
                            .onAppear {
                                checkWishlistProductExist(product.productId, index: i)
                            }
                            
                        }
                        .padding([.top, .leading, .trailing])
                        
                    }
                }
                
            }
            
            VStack {
                Button(action: {
                    withAnimation {
                        showProduct = false
                    }
                }) {
                    let close = lang["close"] ?? "Close"
                    Text(close)
                        .foregroundColor(.red)
                }
                if showProduct {
                    productView
                } else {
                    AnyView(EmptyView())
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .background()
            .offset(x: showProduct ? offsetX : UIScreen.main.bounds.width)
            
        }
        .onAppear {
            if testView {
                initTestView()
            } else {
//                shoppingCart.get() {
                    let count = shoppingCart.elements.count
                    heartIcon = repeatElement("heart", count: count).reversed()
//                }
            }
        }
        .background()
    }
        
        
        
    
    
    func checkWishlistProductExist(_ productId: String, index: Int) {
        let wishlist = Load<ShoppingCart>("/api/renewWishlist/")
        wishlist.get() {
            if wishlist.elements.map({ $0.productId == productId }).contains(true) {
                heartIcon[index] = "heart.fill"
            } else {
                heartIcon[index] = "heart"
            }
        }
    }
    
    func initTestView() {
        shoppingCart.elements = [
            ShoppingCart(),
            ShoppingCart(),
            ShoppingCart()
        ]
        let count = shoppingCart.elements.count
        heartIcon = repeatElement("heart", count: count).reversed()
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(shoppingCart: Load<ShoppingCart>(), testView: true)
    }
}
