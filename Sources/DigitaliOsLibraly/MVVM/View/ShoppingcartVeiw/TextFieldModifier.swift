//
//  TextFieldModifier.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 24.04.2022.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .foregroundColor(Color.textCard)
            .frame(width: UIScreen.main.bounds.width - 45, height: 40)
            .lineLimit(1)
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.textDarkWhiteSet, lineWidth: 2)
                )
    }
}

struct TextFieldModifier_Previews: PreviewProvider {
    @State var name = "safdsa"
    static var previews: some View {
        TextField("Name", text: Self().$name)
            .modifier(TextFieldModifier())
    }
}
