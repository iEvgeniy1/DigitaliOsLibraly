//
//  AddressView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 25.03.2022.
//

import SwiftUI

struct AddressView: View {
    @StateObject var user = Load<User>("/api/login/getUserBySession")
    @State var country = ""
    @State var city = ""
    @State var address = ""
    
    @State var alertCountry: Color = .clear
    @State var alertCity: Color = .clear
    @State var alertAddress: Color = .clear
    
    @State var showingAlert: Bool = false {
        didSet {
            alertCountry  = .clear
            alertCity  = .clear
            alertAddress  = .clear
        }
    }
    var body: some View {
        VStack(alignment: .center) {
            let addressDelivery = lang["user_addressForDelivery"] ?? "Delivery address"
            Text(addressDelivery)
            
            Spacer()
            
            VStack(spacing: 1) {
                HStack {
                    Text(lang["country"] ?? "Country")
                    Spacer()
                }
                .padding(.leading, 21.0)
                TextField(lang["country"] ?? "Country", text: self.$country)
                    .modifier(TextFieldModifier())
                    .background(alertCountry)
                    .cornerRadius(10)
                    .onTapGesture {
                        alertCountry = .clear
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
                    .background(alertCity)
                    .cornerRadius(10)
                    .onTapGesture {
                        alertCity = .clear
                    }
            }
            VStack(spacing: 1) {
                HStack {
                    Text(lang["address"] ?? "Address")
                    Spacer()
                }
                .padding(.leading, 21.0)
                TextField(lang["address"] ?? "Address", text: self.$address)
                    .modifier(TextFieldModifier())
                    .background(alertAddress)
                    .cornerRadius(10)
                    .onTapGesture {
                        alertAddress = .clear
                    }
            }
            
            Spacer()
            
            let okText = lang["looksGood"] ??  "Everything is fine!"
            
            Button(action: {
                user.path = "/api/cabinet/addressPut"
                user.value?.country = country
                user.value?.city = city
                user.value?.address = address
                if country == "" {
                    alertCountry = .red
                } else if city == "" {
                    alertCity = .red
                } else if address == "" {
                    alertAddress = .red
                } else {
                    showingAlert = true
                    user.post()
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
                country = user.value?.country ?? "no country"
                city = user.value?.city ?? "no city"
                address = user.value?.address ?? "no address"
            }
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView()
    }
}
