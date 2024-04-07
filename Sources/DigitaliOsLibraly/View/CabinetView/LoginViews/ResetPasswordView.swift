//
//  ResetPasswordView.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 10.03.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import SwiftUI


struct ResetPasswordView: View {
    
    struct Mail: Codable {
        var mail: String?
    }
    
    @State var emailAddress: String = ""
    
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertDescription: String = ""
    
    var body: some View {
        VStack {
            
            Text(lang["resetPassword"] ?? "Reset your password?")
                .font(.largeTitle)
                .padding([.leading, .bottom, .trailing])
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 7)
                    .foregroundColor(Color(#colorLiteral(red: 0.921269834, green: 0.921269834, blue: 0.921269834, alpha: 0.7444707306)))
                TextField(lang["email"] ?? "Email", text: $emailAddress)
                    .padding(.leading)
                    .autocapitalization(.none)
                
            }
            .frame(width: 220.0, height: 40.0)
            
            Button(lang["reset"] ?? "Reset") {
                UIApplication.shared.endEditing()
                let resetPassword = Load<Mail>("/api/login/forget/")
                resetPassword.value = Mail(mail: emailAddress)
                resetPassword.post() { response in
                    showAlert = true
                    switch response {
                    case .failure(let statusCode, _):
                        switch statusCode {
                        case 200:
                            alertTitle = lang["success"] ?? "Success"
                            alertDescription = lang["passwordResetEmailSent"] ?? "Password Reset Email Sent. The letter can be sent within five minutes."
                        default:
                            alertTitle = lang["problems"] ?? "Problems"
                            alertDescription = lang["unknownError"] ?? "Check the spelling of the email address"
                        }
                    case .successOne(_):
                        alertTitle = lang["success"] ?? "Success"
                        alertDescription = lang["passwordResetEmailSent"] ?? "Password Reset Email Sent. The letter can be sent within five minutes."
                    case .successArray(_):
                        print("Error in resetPassword.post(), get array instead struct")
                    }
                     
                }
            }
            .padding(.top, 25.0)
            .buttonStyle(FullButtonStyleWidthFrame(.textWhiteDarkSet, .yellowSet, width: 220, height: 40))
            
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertDescription), dismissButton: .default(Text(lang["ok"] ?? "Ok")))
        }
        .navigationBarTitle(lang["forgottenYourPassword"] ?? "Forgotten your password?", displayMode: .inline)
    }
    
    
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
