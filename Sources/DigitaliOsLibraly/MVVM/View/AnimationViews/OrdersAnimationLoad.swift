//
//  OrdersAnimationLoad.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 16.03.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import SwiftUI

struct OrdersAnimationLoad: View {
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State var timeInterval: Int = 0
    @State private var opacity = 0.1
    @State private var plusOrMinus: Bool = true
    @State private var title: String = "loading"
    
    init() {
        title = "loading"
    }
    
    var body: some View {
        
        ScrollView {
            ForEach(0..<6) { _ in
                
                VStack {
                    
                    
                    HStack(spacing: 10) {
                        Rectangle()
                            .frame(height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                            .cornerRadius(5)
                            .padding(.horizontal)
                        Rectangle()
                            .frame(height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                            .cornerRadius(5)
                            .padding(.horizontal)
                        HStack {
                            Rectangle()
                                .frame(height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                .cornerRadius(5)
                                .padding(.horizontal)
                            
                        }
                    }
                    .padding(.top)
                    
                    Rectangle()
                        .frame(height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .cornerRadius(5)
                        .padding(.horizontal)
                    
                }
                .padding(.bottom)
                .frame(width: UIScreen.main.bounds.width - 25, height: 100)
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 3)
                    )
                .padding(.bottom)
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle(Text(title), displayMode: NavigationBarItem.TitleDisplayMode.inline)
        .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
        
        
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
            internetSpeedControl()
        }
        
    }
    
    func internetSpeedControl() {
        timeInterval += 1
        if timeInterval/20 > 5 {
            if timeInterval%20 == 0 && timeInterval/20 < 15 {
                title += "."
            }
            if timeInterval/20 == 15 {
                title = lang["pleaseCheckInternet"] ?? "Please, check the internet connection"
            }
        }
    }
}

struct CircleAnimationLoad_Previews: PreviewProvider {
    static var previews: some View {
        OrdersAnimationLoad()
    }
}
