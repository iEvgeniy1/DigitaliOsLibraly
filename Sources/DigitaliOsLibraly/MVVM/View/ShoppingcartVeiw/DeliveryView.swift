//
//  DeliveryView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 30.03.2022.
//

import SwiftUI

struct DeliveryView: View {
    @StateObject var user:           Load<User> = .init("/api/login/getUserBySession/")
    @StateObject var settingPublic:  Load<SettingPublic> = .init("/api/checkout/settingPublic/")
    @Binding var showSelf: Bool
    @State var showPayment: Bool = false
    @State var wantDelivery: Bool = true
    
    @State var country = "Россия"
    @State var city = ""
    @State var address = ""
    @State var alertColorCountry: Color = .clear
    @State var alertColorCity: Color = .clear
    @State var alertColorAddress: Color = .clear
    
    @State var addressSender = ""
    
    @State var deliveryCompany = 1
    
    var body: some View {
        VStack {
            let deliveryProduct = lang["receivingGoods"] ?? "Receiving the goods"
            Text(deliveryProduct)
            
            Spacer()
            
            let selfDelivery = lang["user_deliveryMethod"] ?? "Delivery method:"
            Text(selfDelivery)
            
            Picker(selection: $deliveryCompany, label: Text("Hello")) {
                Text("Почта России").tag(1)
                Text("СДЕК курьер").tag(2)
                Text("СДЕК пункт выдачи").tag(3)
            }.onChange(of: deliveryCompany) { companyNumber in
                print("delivery company number: \(companyNumber)")
                user.path = "/api/checkout/setComment/"
                switch companyNumber {
                    case 1: user.value?.comment = "Почта России"
                    case 2: user.value?.comment = "СДЕК курьер"
                    case 3: user.value?.comment = "СДЕК пункт выдачи"
                    default: break
                }
                user.post()
            }
            .pickerStyle(SegmentedPickerStyle())
            
//            if wantDelivery {
                VStack(spacing: 1) {
                    HStack {
                        Text(lang["country"] ?? "Country")
                        Spacer()
                    }
                    .padding(.leading, 21.0)
                    TextField(lang["country"] ?? "Country", text: self.$country)
                        .modifier(TextFieldModifier())
                        .background(alertColorCountry)
                        .cornerRadius(10)
                        .onTapGesture {
                            alertColorCountry = .clear
                        }
                }
                VStack(spacing: 1) {
                    HStack {
                        Text(lang["city"] ?? "City")
                        Spacer()
                    }
                    .padding(.leading, 21.0)
                    TextField(lang["city"] ?? "City", text: self.$city)
                        .modifier(TextFieldModifier())
                        .background(alertColorCity)
                        .cornerRadius(10)
                        .onTapGesture {
                            alertColorCity = .clear
                        }
                }
                VStack(spacing: 1) {
                    HStack {
                        Text(lang["user_addressForDelivery"] ?? "Delivery address")
                        Spacer()
                    }
                    .padding(.leading, 21.0)
                    TextField(lang["user_addressForDelivery"] ?? "Delivery address", text: self.$address)
                        .modifier(TextFieldModifier())
                        .background(alertColorAddress)
                        .cornerRadius(10)
                        .onTapGesture {
                            alertColorAddress = .clear
                        }
                }
//            } else {
//                Text(addressSender)
//                    .padding(.horizontal)
//                    .foregroundColor(Color.textCard)
//                    .frame(width: UIScreen.main.bounds.width - 45, height: 185)
//                    .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.textDarkWhiteSet, lineWidth: 2)
//                        )
//                    .padding(.top, 20.0)
//            }
            
            Spacer()
            
            Button(action: {
                if wantDelivery {
                    if country == "" {
                        alertColorCountry = .red
                    } else if city == "" {
                        alertColorCity = .red
                    } else if address == "" {
                        alertColorAddress = .red
                    } else {
                        showPayment.toggle()
                    }
                } else {
                    showPayment.toggle()
                }
                addressSave()
            }) {
                let payment = lang["payment"] ?? "Payment"
                ShoppingcartButton(text: payment)
                    .navigationDestination(isPresented: $showPayment) {
                        ReviewOrderView(showSelf: $showPayment)
                    }
            }
            
        }
        .padding(.horizontal)
        .onAppear {
            user.get() {
                wantDelivery = user.value?.needDelivery == false ? false : true
                country = (user.value?.country ?? "") == "" ? country : (user.value?.country ?? "")
                city = user.value?.city ?? ""
                address = user.value?.address ?? ""
                
                switch user.value?.comment {
                    case "Почта России": deliveryCompany = 1
                    case "СДЕК курьер": deliveryCompany = 2
                    case "СДЕК пункт выдачи": deliveryCompany = 3
                    default: deliveryCompany = 1
                }
            }
            settingPublic.get() {
                addressSender = settingPublic.value?.addressSender ?? "address isn't set"
            }
        }
    }
    
    func addressSave() {
        user.path = "/api/cabinet/addressPut"
        user.value?.country = country
        user.value?.city = city
        user.value?.address = address
        user.post()
    }
}

struct DeliveryView_Previews: PreviewProvider {
    @State var showSelf: Bool = true
    @StateObject var user: Load<User> = .init()
    init() {
        self.user.value = User()
    }
    static var previews: some View {
        DeliveryView(user: Self().user, showSelf: Self().$showSelf)
    }
}
