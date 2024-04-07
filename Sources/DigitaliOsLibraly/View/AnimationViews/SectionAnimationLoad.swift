//
//  TransactionAnimationLoad.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 16.03.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import SwiftUI

struct SectionAnimationLoad: View {
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
            ForEach(0..<5) { _ in
                HStack(spacing: 25) {
                    
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .frame(width: 150, height: 200)
                    
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .frame(width: 150, height: 200)
                    
                }
                .padding(.bottom)
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

struct TransactionAnimationLoad_Previews: PreviewProvider {
    static var previews: some View {
        SectionAnimationLoad()
    }
}
