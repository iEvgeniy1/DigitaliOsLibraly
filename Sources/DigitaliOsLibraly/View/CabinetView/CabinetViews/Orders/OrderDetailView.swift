//
//  OrderDetailView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 29.03.2022.
//


import SwiftUI

struct OrderDetailView: View {
    @StateObject var shoppingCart: Load<ShoppingCart>
    @State var showProduct: Bool = false
    @State var productView: AnyView = AnyView(EmptyView())
    @State var offsetX: CGFloat = 0
    
    var testView: Bool = false
    
    var body: some View {
        ZStack {
            
            ScrollView {
                
                ForEach(0..<self.shoppingCart.elements.count, id: \.self) { i in
                    let product = self.shoppingCart.elements[i]
                    
                    HStack(spacing: 10) {
                        
                        ImageLoad(nameImage: product.photo,
                                  width: 75,
                                  height: 75)
                            .cornerRadius(10)
                            .frame(height: 75)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            
                            Text(product.h1)
                                .font(.headline)
                                .foregroundColor(.textDarkWhiteSet)
                                .multilineTextAlignment(.leading)
                            
                            HStack {
                                let priceWithCarancy = product.price == 0 ? "" : String(product.price) + " " + (lang["currency"] ?? "$")
                                Text(priceWithCarancy)
                                    .foregroundColor(Color.cyan)
                                    .font(.headline)
                                
                                Text(" x \(product.count)")
                                    .padding(.leading)
                                
                                let sumThisProductInt = Int(product.price) * (Int(product.count) ?? 0)
                                let sumThisProduct = " = " + String(sumThisProductInt) + " " + (lang["currency"] ?? "$")
                                Text(sumThisProduct)
                                    .foregroundColor(Color.cyan)
                                    .font(.headline)
                            }
                            
                        }
                        
//                        Image(systemName: "repeat")
//                            .resizable()
//                            .frame(width: 25, height: 18)
                        
                    }
                    .padding([.top, .leading, .trailing])
                    
                }
            }
            
        }
        .onAppear {
            if !testView {
                shoppingCart.get()
            }
        }
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    @State var shoppingCart: Load<ShoppingCart>
    init() {
        self.shoppingCart = Load<ShoppingCart>()
        self.shoppingCart.elements.append(ShoppingCart())
        self.shoppingCart.elements.append(ShoppingCart())
        self.shoppingCart.elements.append(ShoppingCart())
        self.shoppingCart.elements.append(ShoppingCart())
    }
    static var previews: some View {
        OrderDetailView(shoppingCart: Self().shoppingCart, testView: true)
    }
}
