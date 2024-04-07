//
//  ShoppingcartButton.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 24.04.2022.
//

import SwiftUI

struct ShoppingcartButton: View {
    var text: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.red)
            Text(text)
                .foregroundColor(.white)
        }
        .frame(height: 40)
        .padding(.horizontal, 50.0)
        .padding(.bottom, 15)
        .padding(.top, 5.0)
    }
}

struct ShoppingcartButton_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingcartButton(text: "Hello world")
    }
}
