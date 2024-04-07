//
//  ProductCard.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 15.04.2022.
//

import SwiftUI

struct ProductCard: View {
    var productId: UUID
    var productName: String
    var imagePath: String
    var price: String
    var width: CGFloat
    var body: some View {
        ZStack {
            ImageLoad(nameImage: imagePath, width: width, height: 210)
                
//                .cornerRadius(10)
//                .frame(width: UIScreen.main.bounds.width-100, height:  UIScreen.main.bounds.width-100)
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color.backgroundCard)
                    
                    VStack {
                        Text(productName)
                            .foregroundColor(Color.textCard)
                            .font(.caption)
                            .lineLimit(1)
                            .padding(.horizontal, 2.0)
                        let priceWithCarancy = price == "0" ? "" : String(price) + " " + (lang["currency"] ?? "$")
                        Text(String(priceWithCarancy))
                            .foregroundColor(Color.cyan)
                            .font(.footnote)
                            .padding(.bottom, 10.0)
                    }
                }
                .frame(height: 50)
            }
            
            
        }
        .frame(width: width, height: 200)
        .background(Color.backgroundCard)
        
    }
        
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        ProductCard(productId: UUID(),
                    productName: "Good product",
                    imagePath: "/images/cms/data/byusti/Gaia/bezymyannyj43.png",
                    price: "2500",
                    width: 150)
    }
}
