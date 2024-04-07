//
//  SectionCard.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 17.04.2022.
//

import SwiftUI

struct SectionCard: View {
    var productId: UUID
    var productName: String
    var imagePath: String
    var width: CGFloat
    var body: some View {
        ZStack {
            ImageLoad(nameImage: imagePath, width: width, height: 225)
                
//                .cornerRadius(10)
//                .frame(width: UIScreen.main.bounds.width-100, height:  UIScreen.main.bounds.width-100)
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color.backgroundSection)
                    
                    Text(productName)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.textCard)
                        .font(.caption)
                        .lineLimit(2)
                        .padding(.horizontal, 2.0)
                }
                .frame(height: 40)
            }
            .frame(height: 200)
            
        }
        .frame(width: width, height: 200)
        .background(Color.backgroundCard)
        
    }
        
}

struct SectionCard_Previews: PreviewProvider {
    static var previews: some View {
        SectionCard(productId: UUID(),
                    productName: "Good product",
                    imagePath: "/images/cms/data/byusti/Gaia/bezymyannyj43.png", width: 150)
    }
}
