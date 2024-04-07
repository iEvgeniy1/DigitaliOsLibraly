//
//  CabinetOrLoginView.swift.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 25.03.2022.
//

import SwiftUI

struct CabinetOrLoginView: View {
    @StateObject var user = Load<User>("/api/login/getUserBySession")
    @ObservedObject var notification: NotificationLabel
    
    @State var showSpinner: Bool = true
    @State var showLoginView: Bool = false
    
    @Binding var mark: ShowView
    @Binding var dark: Bool
    @Binding var show: Bool
    
    var testView: Bool = false
    
    var body: some View {
        let close = lang["close"] ?? "Close"
        VStack {
            if showSpinner {
                Spinner()
            } else {
                if showLoginView {
                    LoginView(show: $showLoginView)
                } else {
                    Menu(mark: $mark,
                         showLoginView: $showLoginView,
                         dark: $dark,
                         show: $show,
                         notification: notification)
                }
            }
            Spacer()
            
            HStack {
                Button(action: {
                    
                    withAnimation(.default) {
                        self.show.toggle()
                    }
                    
                }) {
                    Spacer()
                    Text(close)
                    Spacer()
                    Image(systemName: "chevron.right").resizable().frame(width: 12, height: 20).padding(.trailing)
                    
                }
                
            }
            .padding(.top)
            .padding(.bottom, 30)

        }
        .frame(width: UIScreen.main.bounds.width / 1.2)
        .background((self.dark ? Color.black : Color.white).edgesIgnoringSafeArea(.all))
        .overlay(Rectangle().stroke(Color.primary.opacity(0.2), lineWidth: 2).shadow(radius: 3).edgesIgnoringSafeArea(.all))
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("showOrders"))) { notification in
            getUser()
        }
        .onAppear {
            if testView {
                user.value = User(userExist: false)
            } else {
                getUser()
            }
        }
        
    }
    
    func getUser() {
        user.get() {
            if let userExist = user.value?.userExist, userExist == true {
                showLoginView = false
            } else {
                showLoginView = true
            }
            showSpinner = false
        }
    }
    
}

struct CabinetOrLoginView_Previews: PreviewProvider {
    @StateObject var notification: NotificationLabel = NotificationLabel()
    @State var dark = false
    @State var showBar = false
    @State var mark: ShowView = .catalog
    static var previews: some View {
        CabinetOrLoginView(notification: Self().notification,
                           mark: Self().$mark,
                           dark: Self().$dark,
                           show: Self().$showBar,
                           testView: true)
    }
}
