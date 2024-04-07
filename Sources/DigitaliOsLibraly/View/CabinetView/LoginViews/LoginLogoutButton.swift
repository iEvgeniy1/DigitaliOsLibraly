//
//  LoginLogoutButton.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 25.03.2022.
//

import SwiftUI

struct LoginLogoutButton: View {
    @StateObject var user = Load<User>("/api/login/getUserBySession")
    
    @State var spiner: Bool = false
    
    @Binding var username: String
    @Binding var password: String
    @Binding var show: Bool
    @Binding var alertMessage: String
    @Binding var showAlert: Bool
    
    var body: some View {
        
        let checkEmail = lang["userAuthenticationError"] ?? "Check email or password"
        let checkInternet = lang["pleaseCheckInternet"] ?? "Please, check the internet connection"
        
        let login = lang["logIn"] ?? "Login"
        
        HStack {
            if spiner {
                Spinner()
            } else {
                Button(action: {
                    spiner = true
                    Auth().login(username: self.username, password: self.password) { result in
                        spiner = false
                        switch result {
                        case .failure:
                            alertMessage = checkEmail + " " + checkInternet
                            showAlert = true
                            print("Session failure")
                        case .success(let loginCondition):
                            print("Session success")
                            switch loginCondition {
                            case "mailNowAuth":
                                self.user.path = "/api/login/getUserBySession"
                                self.user.get() {
                                    self.show = false
                                    DispatchQueue.main.async {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showDelivery"), object: nil)
                                    }
                                }
                            
                            default:
                                alertMessage = checkEmail
                                showAlert = true
                            }
                            
                        }
                    }
                }) {
                    Text(login)
                        .foregroundColor(.textWhiteDarkSet)
                }
                .buttonStyle(ButtonStyleFullRelative(.textDarkWhiteSet))
            }
              
            
        }
    }
}

struct LoginLogoutButton_Previews: PreviewProvider {
    @State var username = ""
    @State var password = ""
    @State var show: Bool = true
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    
    static var previews: some View {
        LoginLogoutButton(username: Self().$username,
                          password: Self().$password,
                          show: Self().$show,
                          alertMessage: Self().$alertMessage,
                          showAlert: Self().$showAlert)
    }
}
