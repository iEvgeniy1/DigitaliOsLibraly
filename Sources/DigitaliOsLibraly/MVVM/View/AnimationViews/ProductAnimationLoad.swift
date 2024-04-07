//
//  CompanyAnimationLoad.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 16.03.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import SwiftUI

struct ProductAnimationLoad: View {
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
            ForEach(0..<2) { _ in
                VStack(spacing: 0) {
                    
                    Rectangle()
                        .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)))
                        .frame(width: 125, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .cornerRadius(5)
                        .padding(.vertical)
                    
                    Rectangle()
                        .cornerRadius(10)
                        .padding(.bottom)
                        .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .frame(width: 300, height: 300)
                    
                    HStack {
                        
                        
                        VStack(spacing: 10) {
                            Rectangle()
                                .frame(height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                .cornerRadius(5)
                                .padding(.horizontal)
                            Rectangle()
                                .frame(height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                .cornerRadius(5)
                                .padding(.horizontal)
                            HStack {
                                Rectangle()
                                    .frame(width: 100, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                    .cornerRadius(5)
                                    .padding(.horizontal)
                                Spacer()
                            }
                        }
                        
                    }
                    .padding([.leading, .bottom, .trailing])
                    
                    
                    
                    
                }
            }
            Spacer()
        }
        .padding(.top)
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

struct CompanyAnimationLoad_Previews: PreviewProvider {
    static var previews: some View {
        ProductAnimationLoad()
    }
}
