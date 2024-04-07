//
//  ProfileButton.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 26.04.2022.
//

import SwiftUI

struct ProfileButton: View {
    var text: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.yellowSet)
            Text(text)
                .foregroundColor(.white)
        }
        .frame(height: 40)
        .padding(.horizontal, 50.0)
        .padding(.bottom, 15)
        .padding(.top, 5.0)
    }
}

struct ProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        ProfileButton(text: "Save")
    }
}
