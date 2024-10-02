//
//  CheckoutView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 30.03.2022.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject var user: Load<User> = .init("/api/login/getUserBySession/")
    @StateObject var settingPublic:  Load<SettingPublic> = .init("/api/checkout/settingPublic/")
    @Binding var showSelf: Bool
    @State var showDelivery: Bool = false
    @State var showLogin: Bool = false
    
    @State var name = ""
    @State var mail = ""
    @State var phone = ""
    
    @State var alertColorName: Color = .clear
    @State var alertColorMail: Color = .clear
    @State var alertColorPhone: Color = .clear
    var body: some View {
        VStack(alignment: .center) {
            let contacts = lang["contactInformation"] ?? "Contact information"
            Text(contacts)
            
            Spacer()
            
            VStack(spacing: 15) {
                VStack(spacing: 1) {
                    HStack {
                        Text(lang["yourName"] ?? "Your name")
                        Spacer()
                    }
                    .padding(.leading, 21.0)
                    TextField(lang["name"] ?? "Name", text: self.$name)
                        .modifier(TextFieldModifier())
                        .background(alertColorName)
                        .cornerRadius(10)
                        .onTapGesture {
                            alertColorName = .clear
                        }
                }
                
                VStack(spacing: 1) {
                    HStack {
                        Text(lang["mail"] ?? "Email")
                            
                        Spacer()
                    }
                    .padding(.leading, 21.0)
                    TextField(lang["mail"] ?? "Email", text: self.$mail)
                        .modifier(TextFieldModifier())
                        .background(alertColorMail)
                        .cornerRadius(10)
                        .onTapGesture {
                            alertColorMail = .clear
                        }
                        .autocapitalization(.none)
                }
                
                VStack(spacing: 1) {
                    HStack {
                        Text(lang["phone"] ?? "Phone")
                        Spacer()
                    }
                    .padding(.leading, 21.0)
                    TextField(lang["phone"] ?? "Phone", text: self.$phone)
                        .modifier(TextFieldModifier())
                        .background(alertColorPhone)
                        .cornerRadius(10)
                        .onTapGesture {
                            alertColorPhone = .clear
                        }
                }
            }
            
            Spacer()
            
            Button(action: {
                if name == "" {
                    alertColorName = .red
                } else if mail == "" {
                    alertColorMail = .red
                } else if phone == "" {
                    alertColorPhone = .red
                } else {
                    userCreate()
                }
            }) {
                if settingPublic.value?.mobilDelivery == true {
                    let delivery = lang["delivery"] ?? "Delivery"
                    ShoppingcartButton(text: delivery)
                        .navigationDestination(isPresented: $showDelivery) {
                            DeliveryView(showSelf: $showDelivery)
                        }
                } else {
                    let delivery = lang["confirmation"] ?? "confirmation"
                    ShoppingcartButton(text: delivery)
                        .navigationDestination(isPresented: $showDelivery) {
                            ReviewOrderView(showSelf: $showDelivery)
                        }
                }
            }
            
        }
        .fullScreenCover(isPresented: $showLogin, content: {
            NavigationView {
                LoginView(username: mail, show: $showLogin)
                    .navigationBarTitle(Text(""), displayMode: .inline)
                    .navigationBarItems(trailing: Button(lang["close"] ?? "Close") { showLogin.toggle() })
                    .navigationViewStyle(StackNavigationViewStyle()) // delete mistakes in terminal with constrains
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("showDelivery"))) { _ in
            showDelivery = true
        }
        .onAppear {
            user.get() {
                if user.value?.userExist == true {
                    name = user.value?.name ?? ""
                    mail = user.value?.mail ?? ""
                    phone = user.value?.phone ?? ""
                }
            }
            settingPublic.get()
        }
    }
    
    func userCreate() {
        user.path = "/api/checkout/"
        user.value?.name = name
        user.value?.mail = mail
        user.value?.phone = phone
        user.post { responce in
            switch responce {
            case.successOne(let checkout):
                print(checkout)
                switch checkout.loginCondition {
                case "mailNowAuth", "mailWasFree":
                    print("showDelivery = true")
                    showDelivery.toggle()
                case "mailIsBusy":
                    showLogin = true
                default:
                    print(checkout.loginCondition ?? "error loginCondition")
                }
                
            default:
                print("error userCreate")
            }
            
        }
    }
    
}

struct CheckoutView_Previews: PreviewProvider {
    @State var showSelf: Bool = true
    static var previews: some View {
        CheckoutView(showSelf: Self().$showSelf)
            .preferredColorScheme(.dark)
    }
}
