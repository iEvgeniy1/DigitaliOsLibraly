//
//  KeyboardResponsiveModifier.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 04.07.2020.
//  Copyright © 2020 EVGENIY DAN. All rights reserved.
//


import SwiftUI

// чтобы работало поднятие клавиатуры используется функция .keyboardResponsive()
public struct KeyboardResponsiveModifier: ViewModifier {
    public init() { }
    @State public var top: CGFloat = 0
    @State public var bottom: CGFloat = 0
    
    public func body(content: Content) -> some View {
        content
            .padding(.top, top)
            .padding(.bottom, bottom)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
                    let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    withAnimation(.default) {
                        self.top = 75
                        self.bottom = value.height-75
                    }
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notif in
                    self.top = 0
                    self.bottom = 0
                }
        }
    }
}

extension View {
    public func keyboardResponsive() -> ModifiedContent<Self, KeyboardResponsiveModifier> {
    //return withAnimation(.default) { modifier(KeyboardResponsiveModifier()) }
    return modifier(KeyboardResponsiveModifier())
  }
}

extension UIApplication {
    public func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

