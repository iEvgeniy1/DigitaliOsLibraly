//
//  ProfileView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 22.03.2022.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var user = Load<User>("/api/login/getUserBySession")
    @State var name = ""
    @State var surname = ""
    @State var mail = ""
    @State var phone = ""
    @State var password = ""
    @State var newPassword = ""
    
    @State var alertColorPassword: Color = .clear
    @State var alertColorNewPassword: Color = .clear
    
    @State var showingAlert: Bool = false {
        didSet {
            alertColorPassword  = .clear
            alertColorNewPassword  = .clear
            password = ""
            newPassword = ""
        }
    }
    var body: some View {
        VStack(alignment: .center) {
            let profileData = lang["profileData"] ?? "Profile Data"
            Text(profileData)
            
            Spacer()
            
            VStack(spacing: 1) {
                HStack {
                    Text(lang["name"] ?? "Name")
                    Spacer()
                }
                .padding(.leading, 21.0)
                TextField(lang["name"] ?? "Name", text: self.$name)
                    .modifier(TextFieldModifier())
                    .cornerRadius(10)
            }
            VStack(spacing: 1) {
                HStack {
                    Text(lang["surname"] ?? "Surname")
                    Spacer()
                }
                .padding(.leading, 21.0)
                TextField(lang["surname"] ?? "Surname", text: self.$surname)
                    .modifier(TextFieldModifier())
                    .cornerRadius(10)
            }
            VStack(spacing: 1) {
                HStack {
                    Text(lang["mail"] ?? "Email")
                    Spacer()
                }
                .padding(.leading, 21.0)
                TextField(lang["mail"] ?? "Email", text: self.$mail)
                    .modifier(TextFieldModifier())
                    .cornerRadius(10)
            }
            VStack(spacing: 1) {
                HStack {
                    Text(lang["phone"] ?? "Phone")
                    Spacer()
                }
                .padding(.leading, 21.0)
                TextField(lang["phone"] ?? "Phone", text: self.$phone)
                    .modifier(TextFieldModifier())
                    .cornerRadius(10)
            }
            VStack(spacing: 1) {
                HStack {
                    Text(lang["info_forgetKeywords"] ?? "Change password")
                    Spacer()
                }
                .padding(.leading, 21.0)
                TextField(lang["password"] ?? "Password", text: self.$password)
                    .modifier(TextFieldModifier())
                    .background(alertColorPassword)
                    .cornerRadius(10)
                    .onTapGesture {
                        alertColorPassword = .clear
                    }
            }
            VStack(spacing: 1) {
                HStack {
                    Text(lang["user_createNewPassword"] ?? "Repeat new password")
                    Spacer()
                }
                .padding(.leading, 21.0)
                TextField(lang["user_repeatPassword"] ?? "Repeat password", text: self.$newPassword)
                    .modifier(TextFieldModifier())
                    .background(alertColorNewPassword)
                    .cornerRadius(10)
                    .onTapGesture {
                        alertColorNewPassword = .clear
                    }
            }
            
            Spacer()
            
            let okText = lang["looksGood"] ??  "Ok"
            
            Button(action: {
                user.path = "/api/cabinet/profilePut"
                user.value?.name = name
                user.value?.surname = surname
                user.value?.mail = mail
                user.value?.phone = phone
                user.value?.password = password
                user.value?.picture = ""
                
                if password != "" {
                    if password == newPassword {
                        userPost()
                    } else {
                        if newPassword == "" {
                            alertColorNewPassword = .red
                        } else {
                            alertColorPassword = .red
                            alertColorNewPassword = .red
                        }
                    }
                } else {
                    userPost()
                }
                
            }) {
                let save = lang["save"] ??  "Save"
                ProfileButton(text: save)
                    .padding(.top, 3.0)
            }
            .alert(okText, isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
            
        }
        .padding(.leading, 20.0)
        .onAppear {
            user.get {
                name = user.value?.name ?? "no name"
                surname = user.value?.surname ?? "no surname"
                mail = user.value?.mail ?? "no mail"
                phone = user.value?.phone ?? "no phone"
            }
        }
    }
    
    
    func userPost() {
        user.post() {
            showingAlert = true
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
