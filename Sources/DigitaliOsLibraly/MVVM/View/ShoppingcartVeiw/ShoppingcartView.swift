//
//  ShoppingcartView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 22.03.2022.
//

import SwiftUI

struct ShoppingcartView: View {
    @StateObject var shoppingCart: Load<ShoppingCart>
    @State var showCheckout: Bool = false
    
    @State var bucketIcon: [String] = []
    @State var buttonColor: Color = .yellowSet
    
    @State var productCount: [Int] = []
    @State var productDescription: [String] = []
    
    @State var showProduct: Bool = false
    @State var productView: AnyView = AnyView(EmptyView())
    @State var offsetX: CGFloat = 0
    
    var testView: Bool = false
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                VStack {
                    
                    let bucket = lang["shoppingcart"] ?? "Shopping cart"
                    Text(bucket)
                    
                    ScrollView {
                        
                        ForEach(0..<self.bucketIcon.count, id: \.self) { i in
                            let product = self.shoppingCart.elements[i]
                            
                            HStack(spacing: 10) {
                                
                                ImageLoad(nameImage: product.photo,
                                          width: 75,
                                          height: 75)
                                    .cornerRadius(10)
                                    .frame(height: 75)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    HStack {
                                        Button(action: {
                                            productView = AnyView(LoadProduct(product: Load<Product>("/api/p/\(product.url)/")))
                                            showProduct.toggle()
                                        }) {
                                            Text(product.h1)
                                                .font(.headline)
                                                .foregroundColor(.textDarkWhiteSet)
                                                .multilineTextAlignment(.leading)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            let addOrDelete = bucketIcon[i] == "trash" ? "delete/\(product.productId)/" : "add/\(product.productId)/1/"
                                            let shoppingCart = Load<Product>("/api/" + addOrDelete)
                                            shoppingCart.get() {
                                                DispatchQueue.main.async {
                                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "needRenewShoppingCart"), object: nil)
                                                }
                                            }
                                            bucketIcon[i] = bucketIcon[i] == "trash" ? "trash.slash" : "trash"
                                        }) {
                                            Image(systemName: bucketIcon[i])
                                                .resizable()
                                                .foregroundColor(.red)
                                                .frame(width: 15, height: 17)
                                                .padding(.trailing, 15.0)
                                        }
                                        .onAppear {
                                            checkShoppingCartProductExist(product.productId, index: i)
                                        }
                                    }
                                    
                                    
                                    HStack {
                                        let priceWithCarancy = product.price == 0 ? "" : String(product.price) + " " + (lang["currency"] ?? "$")
                                        Text(priceWithCarancy)
                                            .foregroundColor(Color.cyan)
                                            .font(.headline)
                                        
                                        Stepper(" x \(productCount[i])", onIncrement: {
                                            productCount[i] += 1
                                            Load<Product>("/api/put/\(product.productId)/\(productCount[i])").get()
                                        }, onDecrement: {
                                            let count = productCount[i] - 1
                                            productCount[i] = count == 0 ? 1 : count
                                            Load<Product>("/api/put/\(product.productId)/\(productCount[i])").get()
                                        })
                                        .padding(.leading)
                                    }
                                    
                                    HStack {
                                        let description = productDescription[i]
                                        Text(description)
                                            .foregroundColor(.textDarkWhiteSet)
                                            .font(.subheadline)
                                    }
                                    
                                }
                                
                            }
                            .padding([.top, .leading, .trailing])
                            
                        }
                    }
                    .navigationBarHidden(true)
                    
                    Button(action: {
                        showCheckout = true
                    }) {
                        let createOrder = lang["user_makingAnOrder"] ?? "Making the order"
                        ShoppingcartButton(text: createOrder)
                    }
                    .navigationDestination(isPresented: $showCheckout) {
                        CheckoutView(showSelf: $showCheckout)
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
            .offset(y: showProduct ? offsetX : UIScreen.main.bounds.height)
        }
        .onAppear {
            if testView {
                initTestView()
            } else {
//                shoppingCart.get() { cart in
                    let count = shoppingCart.elements.count
                    bucketIcon = repeatElement("trash", count: count).reversed()
                    productCount = shoppingCart.elements.map { Int($0.count) ?? 0 }
                    productDescription = shoppingCart.elements.map { $0.description }
//                }
            }
        }
        
    }
    
    func checkShoppingCartProductExist(_ productId: String, index: Int) {
        let wishlist = Load<ShoppingCart>("/api/renewShoppingCart/")
        wishlist.get() {
            if wishlist.elements.map({ $0.productId == productId }).contains(true) {
                bucketIcon[index] = "trash"
            } else {
                bucketIcon[index] = "trash.slash"
            }
        }
    }
    
    func initTestView() {
        shoppingCart.elements.append(ShoppingCart())
        shoppingCart.elements.append(ShoppingCart())
        shoppingCart.elements.append(ShoppingCart())
        shoppingCart.elements.append(ShoppingCart())
        shoppingCart.elements.append(ShoppingCart())
        shoppingCart.elements.append(ShoppingCart())
        shoppingCart.elements.append(ShoppingCart())
        
        let count = shoppingCart.elements.count
        bucketIcon = repeatElement("trash", count: count).reversed()
        
        productCount = shoppingCart.elements.map { Int($0.count) ?? 0 }
        productDescription = shoppingCart.elements.map { $0.description }
    }
}

struct ShoppingcartView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingcartView(shoppingCart: Load<ShoppingCart>(), testView: true)
    }
}
