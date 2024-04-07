//
//  ButtonsStyle.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 01.02.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import SwiftUI


//MARK: Universal Buttons
//ButtonStyleFullRelative(.darkWhiteSet)
struct ButtonStyleFullRelative: ButtonStyle {
    
    var textCollor: Color
    var background: Color
    var width: CGFloat
    var height: CGFloat
    
    init(_ background: Color) {
        self.textCollor = .textWhiteDarkSet
        self.background = background
        self.width = UIScreen.main.bounds.width / 1.75
        self.height = 40
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(background)
                            .frame(width: width, height: height))
            .foregroundColor(configuration.isPressed ? textCollor.opacity(0.5) : textCollor)
    }
    
}

struct ButtonStyleFullСoverSmall: ButtonStyle {
    
    var textCollor: Color
    var background: Color
    var width: CGFloat
    var height: CGFloat
    
    init(text: String, _ background: Color) {
        let width = text.widthOfString(usingFont: UIFont.systemFont(ofSize: 22, weight: .bold))
        self.textCollor = .white
        self.background = background
        self.width = width
        self.height = 31
    }
    init(text: String, _ background: Color, textCollor: Color) {
        self.init(text: text, background)
        self.textCollor = textCollor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(background)
                            .frame(width: width, height: height))
            .foregroundColor(configuration.isPressed ? textCollor.opacity(0.5) : textCollor)
    }
    
}

//ButtonStyleFullFrame(.yellowSet)
struct ButtonStyleFullFrame: ButtonStyle {
    
    var textCollor: Color
    var background: Color
    var width: CGFloat
    var height: CGFloat
    
    init(_ background: Color) {
        self.textCollor = .white
        self.background = background
        self.width = UIScreen.main.bounds.width-32
        self.height = 40
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(background)
                            .frame(width: width, height: height))
            .foregroundColor(configuration.isPressed ? textCollor.opacity(0.5) : textCollor)
    }
    
}




//MARK: Old Buttons

struct EmptyButtonStyle: ButtonStyle {
    
    var collor: Color
//    let size = "выбрать".widthOfString(usingFont: UIFont.systemFont(ofSize: 17, weight: .bold))
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            //.frame(width: size, height: 31, alignment: .center)
            //.background(Color.red)
            .padding(5)
            .foregroundColor(configuration.isPressed ? collor.opacity(0.5) : collor)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(configuration.isPressed ? collor.opacity(0.5) : collor,
                            lineWidth: 1.5)
            )
    }
}


struct FullButtonStyle: ButtonStyle {
    
    var textCollor: Color
    var background: Color
    var padding: CGFloat
    init(_ textCollor: Color, _ background: Color, _ padding: CGFloat) {
        self.textCollor = textCollor
        self.background = background
        self.padding = padding
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .background(background)
            .foregroundColor(configuration.isPressed ? textCollor.opacity(0.5) : textCollor)
            .cornerRadius(5)
    }
    
}



struct FullButtonStyleWidthFrame: ButtonStyle {
    
    var textCollor: Color
    var background: Color
    var width: CGFloat
    var height: CGFloat
    
    init(_ textCollor: Color, _ background: Color, width: CGFloat, height: CGFloat) {
        self.textCollor = textCollor
        self.background = background
        self.width = width
        self.height = height
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(background)
                            .frame(width: width, height: height))
            .foregroundColor(configuration.isPressed ? textCollor.opacity(0.5) : textCollor)
    }
}

struct FullButtonStyleTextSize: ButtonStyle {
    
    var textCollor: Color
    var background: Color
    var padding: CGFloat
    var size: CGFloat
    
    init(_ textCollor: Color, _ background: Color, _ padding: CGFloat, text: String) {
        self.textCollor = textCollor
        self.background = background
        self.padding = padding
        self.size = text.widthOfString(usingFont: UIFont.systemFont(ofSize: 19))
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size+30)
            .padding(padding)
            .background(background)
            .foregroundColor(configuration.isPressed ? textCollor.opacity(0.5) : textCollor)
            .cornerRadius(5)

    }
}


