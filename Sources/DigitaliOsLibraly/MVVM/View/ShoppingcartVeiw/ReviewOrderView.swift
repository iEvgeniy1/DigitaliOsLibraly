//
//  ReviewOrderView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 30.03.2022.
//

import SwiftUI

struct ReviewOrderView: View {
    @StateObject var user: Load<User> = .init("/api/login/getUserBySession/")
    @Binding var showSelf: Bool
    @State var showCreatePassword: Bool = true
    @State var password: String = ""
    @State var repeatPassword: String = ""
    @State var passwordColor: Color = .clear
    @State var repeatPasswordColor: Color = .clear
    var body: some View {
        VStack {
            let createCabinet = lang["user_personalAccount"] ?? "Personal account"
            Text(createCabinet)
            
            Spacer()
            
            if showCreatePassword {
                
                VStack(spacing: 1) {
                    HStack {
                        Text(lang["user_comeUpPassword"] ?? "Come up with a password")
                        Spacer()
                    }
                    .padding(.leading, 21.0)
                    TextField(lang["password"] ?? "Password", text: self.$password)
                        .modifier(TextFieldModifier())
                        .background(passwordColor)
                        .cornerRadius(10)
                        .onTapGesture {
                            passwordColor = .clear
                        }
                }
                .padding(.bottom)
                VStack(spacing: 1) {
                    HStack {
                        Text(lang["user_repeatPassword"] ?? "Repeat the password")
                        Spacer()
                    }
                    .padding(.leading, 21.0)
                    TextField(lang["user_resetPassword"] ?? "Reset password", text: self.$repeatPassword)
                        .modifier(TextFieldModifier())
                        .background(repeatPasswordColor)
                        .cornerRadius(10)
                        .onTapGesture {
                            repeatPasswordColor = .clear
                        }
                }
                
            } else {
                
                Text(lang["orderEndedGoToCabinet"] ?? "The order has been placed, go to your personal account ...")
                    .multilineTextAlignment(.center)
                    .onAppear {
                        
                        user.path = "/api/checkout/goToCabinet/"
                        user.post() {
                            print("Order created go to cabinet: \(String(describing: user.value?.thisOrderIsntCreated))")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showOrders"), object: nil)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setZeroInCart"), object: nil)
                        }
                        
                    }
                
            }
            
            Spacer()
            
            Button(action: {
                
                if password == "" {
                    passwordColor = .red
                } else if repeatPassword == "" {
                    repeatPasswordColor = .red
                } else if password != repeatPassword {
                    passwordColor = .red
                    repeatPasswordColor = .red
                } else {
                    user.value?.password = password
                    user.path = "/api/checkout/goToCabinet/"
                    user.post() {
                        print("status thisOrderIsntCreated: \(String(describing: user.value?.thisOrderIsntCreated))")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showOrders"), object: nil)
                    }
                    
                }
            }) {
                let saveAndGoToCabinet = lang["createCabinet"] ?? "Create a personal account"
                ShoppingcartButton(text: saveAndGoToCabinet)
            }
            
        }
        .onAppear {
            Load<String>("/api/checkout/review/").get()
            user.get() {
                if user.value?.userType == .customerWithoutPassword {
                    showCreatePassword = true
                } else {
                    showCreatePassword = false
                }
            }
        }
    }
}

struct ReviewOrderView_Previews: PreviewProvider {
    @State var showSelf: Bool = true
    static var previews: some View {
        ReviewOrderView(showSelf: Self().$showSelf)
    }
}
