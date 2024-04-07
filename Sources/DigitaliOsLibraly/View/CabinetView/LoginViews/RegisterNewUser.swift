//
//  RegisterNewUser.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 22.05.2020.
//  Copyright © 2020 EVGENIY DAN. All rights reserved.
//

import SwiftUI
//import Combine



struct RegisterNewUser: View {
    @StateObject var user = Load<User>("/api/login/getUserBySession")
    
    @State var newUser = RegisterUser()
    
    @Binding var showSelf: Bool // закрыть себя
    @Binding var showLoginView: Bool
    
    @State var showDengerAlert: Bool = false
    @State var alertMessage: String = ""
    
    
    @State var name: String = ""
    @State var mail: String = ""
    @State var phone: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""

    var body: some View {
        
        ZStack {
            NavigationView {
                
                VStack {
                    
                    Form {
                        
                        TextField(lang["userName"] ??  "Nickname", text: $name)
                            
                        TextField(lang["email"] ?? "Email", text: $mail)
                        
                        TextField(lang["name"] ?? "Phone", text: $phone)
                            
                        TextField(lang["password"] ?? "Password", text: $password)
                        TextField(lang["confirmPassword"] ?? "Confirm password", text: $confirmPassword)
                            
                    }
                    
                    //.ignoresSafeArea(.keyboard, edges: .bottom)//.colorMultiply(.blue)
                    
                    registerButton()
                }
                .navigationBarTitle(Text(lang["register"] ??  "Register new user"), displayMode: .inline)
                .navigationBarItems(trailing: closeButton )
            }
            
            .onAppear {
                UINavigationBar.appearance().barTintColor = .lightGray
            }
            .alert(isPresented: $showDengerAlert) {
                Alert(title: Text(lang["pleaseFixTheFollowingErrors"] ??  "Please!"), message: Text(alertMessage), dismissButton: .default(Text(lang["ok"] ??  "Ok!")))
            }
            .onTapGesture {
                print("All EditUserView taped")
                UIApplication.shared.endEditing()
            }
            
        }
        
    }
    
    func registerButton() -> some View {
        Button(lang["register"] ?? "Register") {
            if checkAllField() {
                let registerData = Load<RegisterUser>()
                registerData.value = .init(name: name,
                                           password: password,
                                           confirmPassword: confirmPassword,
                                           mail: mail,
                                           phone: phone)
                
                registerData.path = "/api/login/register"
                registerData.post() { result in
                    switch result {
                    case .failure(let statusCode, let value):
                        print("result is failure: \(statusCode), value: \(String(describing: value))")
//                        let decode = try! JSONDecoder().decode(String.self, from: value!)
                        let decode = String(decoding: value ?? Data(), as: UTF8.self)
                        alertMessage = decode
                        showDengerAlert = true
                    case .successOne(let value):
                        print("result is success, value: \(String(describing: value))")
                        switch value.loginCondition {
                        case .mailNowAuth, .mailWasFree:
                            auth()
                        default:
                            alertMessage = value.loginCondition?.rawValue ?? "erro show alert message"
                            showDengerAlert = true
                        }
                    case .successArray(_):
                        print("Error in registerData.post(), get array instead struct")
                    }
                }
            } else {
                alertMessage = lang["youNeedToFillInAllFields"] ?? "You need to fill in all the fields"
                showDengerAlert = true
            }
        }
        .buttonStyle(ButtonStyleFullRelative(.textDarkWhiteSet))
        .padding(.bottom, 15.0)
        .padding(.top, 7.0)
    }
    
    var closeButton: some View {
        Button(lang["close"] ??  "Close") {
            showSelf = false
        }
        .foregroundColor(.yellowSet)
    }
    
    func checkAllField() -> Bool {
        if name == "" { return false }
        if mail == "" { return false }
        if phone == "" { return false }
        if password == "" { return false }
        if confirmPassword == "" { return false }
        return true
    }

    
    func auth() {
        Auth().login(username: mail, password: password) { result in
            switch result {
            case .failure:
                print("Token failure")
            case .success:
                print("Token success")
                showSelf = false
                self.user.path = "/api/users/getUserPublic"
                self.user.get() {
                    
                    showLoginView = false
                    
                }
            }
        }
    }
    
}

struct RegisterNewUser_Previews: PreviewProvider {
    
    @State var showSelf: Bool = true
    @State var showLoginView: Bool = true
    
    static var previews: some View {
        Group {
            RegisterNewUser(showSelf: Self().$showSelf, showLoginView: Self().$showLoginView)
                .preferredColorScheme(.light)
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}

