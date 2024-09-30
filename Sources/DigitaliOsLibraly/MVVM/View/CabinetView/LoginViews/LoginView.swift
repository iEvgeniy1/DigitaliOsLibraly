//
//  LoginViewStart.swift.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 24.03.2022.
//

import SwiftUI

struct LoginView: View {
    
    @State var username = ""
    @State var password = ""
    
    @State var showRegisterNewUser: Bool = false
    @State var showResetPassword: Bool = false
    @State var showPrivacyPolicy: Bool = false
    
    @State var auth: Bool = false
    @Binding var show: Bool
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    
    
    var body: some View {
        
        let privacyPolicy = lang["privacyPolicy"] ?? "Privacy Policy"
        let login = lang["logIn"] ?? "Login"
        let password = lang["password"] ?? "Password"
//        let authorization = lang["authorization ?? "Authorization"
        let resetYourPassword = lang["resetPassword"] ?? "Reset your password!?"
        let fixError = lang["pleaseFixTheFollowingErrors"] ??  "Please!"
        let ok = lang["ok"] ??  "Ok!"
        
        
            
            VStack {
                
                
                ScrollView {
                    
                    if auth {
                        Image(systemName: "hand.thumbsup")
                            .resizable()
                            .foregroundColor(.green)
                            .padding(.vertical)
                            .frame(width: 100.0, height: 125.0)
                    } else {
                        Image(systemName: "hand.raised")
                            .resizable()
                            .foregroundColor(.red)
                            .padding(.vertical)
                            .frame(width: 75.0, height: 125.0)
                    }
                    
                    HStack() {
                        Spacer()
                        
                        Button(privacyPolicy) {
                            UIApplication.shared.endEditing()
                            showPrivacyPolicy = true
                        }
                        .foregroundColor(Color("textDarkWhiteSet"))
                        .sheet(isPresented: $showPrivacyPolicy, content: {
                            NavigationView {
                                PrivacyPolicy(showPrivacyPolicy: $showPrivacyPolicy)
                                    .navigationBarTitle(Text(lang["privacyPolicy"] ?? "Privacy policy"), displayMode: .inline)
                                    .navigationBarItems(trailing: Button(lang["close"] ?? "Close") { showPrivacyPolicy.toggle() })
                            }
                        })
                    }
                    .padding(.trailing, 30)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 4)
                            .frame(height: 50.0)
                            .padding(.horizontal)
                        
                        TextField(login, text: self.$username)
                            .autocapitalization(.none)
                            .padding(.leading, 30.0)
                    }.padding()
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 4)
                            .padding(.horizontal)
                            .frame(height: 50.0)
                        
                        TextField(password, text: $password)
                            .autocapitalization(.none)
                            .padding(.horizontal, 30.0)
                    }.padding(.horizontal)
                    
                    HStack() {
                        Spacer()
                        Button(resetYourPassword) {
                            UIApplication.shared.endEditing()
                            showResetPassword = true
                        }
                        .foregroundColor(Color("textDarkWhiteSet"))
                        .sheet(isPresented: $showResetPassword, content: {
                            NavigationView {
                                ResetPasswordView()
                                    .navigationBarTitle(Text(lang["reset"] ?? "Reset password"), displayMode: .inline)
                                    .navigationBarItems(trailing: Button(lang["close"] ?? "Close") { showResetPassword.toggle() })
                            }
                        })
                    }
                    .padding(.trailing, 30)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    LoginLogoutButton(username: $username,
                                      password: $password,
                                      show: $show,
                                      alertMessage: $alertMessage,
                                      showAlert: $showAlert)
                    
                    Spacer()
                        .frame(height: 60)
                    
                    Button(lang["register"] ?? "Register New User") {
                        showRegisterNewUser = true
                    }
                    .buttonStyle(ButtonStyleFullRelative(.yellowSet))
                    .fullScreenCover(isPresented: $showRegisterNewUser, content: {
                        AnyView(RegisterNewUser(showSelf: $showRegisterNewUser, showLoginView: $show))
                    })
                    
                    
                }
                .padding(.top, 30)
//                .navigationBarTitle(Text(authorization), displayMode: .inline)
            }
            .onTapGesture {
                print("All EditUserView taped")
                UIApplication.shared.endEditing()
            }
            .keyboardResponsive()
            .alert(isPresented: $showAlert) {
                Alert(title: Text(fixError), message: Text(alertMessage), dismissButton: .default(Text(ok)))
            }
            .onAppear {
                UINavigationBar.appearance().barTintColor = .lightGray
            }

    }
    


    


    
}

struct LoginViewStart_Previews: PreviewProvider {
    @State var show: Bool = false
    static var previews: some View {
        LoginView(show: Self().$show)
            .preferredColorScheme(.dark)
    }
}
