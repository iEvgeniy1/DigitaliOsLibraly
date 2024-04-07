//
//  AnimationWhenTextFieldLoad.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 31.01.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import SwiftUI

struct AnimationWhenTextFieldLoad: View {
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State private var opacity = 0.1
    @State private var plusOrMinus: Bool = true
    
    var body: some View {
        
        ZStack {
            HStack {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 75, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(5)
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.gray, lineWidth: 1.4)
                        .frame(height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                    Rectangle()
                        .frame(height: 18, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .cornerRadius(5)
                        .padding()
                }
            }
            .padding(.horizontal)
            
        }
        .opacity(opacity)
        .onReceive(timer) { time in
            if plusOrMinus {
                opacity += 0.03
                if opacity > 0.9 {
                    plusOrMinus = false
                }
            } else {
                opacity -= 0.03
                if opacity < 0.2 {
                    plusOrMinus = true
                }
            }
        }
        
    }
    

    
    
}

struct TestSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationWhenTextFieldLoad()
    }
}

