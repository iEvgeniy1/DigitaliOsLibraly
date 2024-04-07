//
//  MainMenu.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 15.01.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import SwiftUI



struct Menu : View {
    @StateObject var user = Load<User>("/api/login/getUserBySession")
    
    @Binding var mark: ShowView
    
    @Binding var showLoginView: Bool
    @Binding var dark: Bool
    @Binding var show: Bool {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showPopUp"), object: nil)
        }
    }
    
    @ObservedObject var notification: NotificationLabel
    
    @State var isShowingImagePicker: Bool = false
    
    var body: some View {
        let logout = lang["logOut"] ?? "Logout"
        
        VStack {
            
            Spacer()
            
            if user.value != nil {
                ImageLoad(nameImage: user.value?.picture ?? User.defaultImagies,
                          width: 85,
                          height: 85)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .onTapGesture {
                        isShowingImagePicker.toggle()
                    }
                    .sheet(isPresented: $isShowingImagePicker, content: {
                        ImageSettingPickerView(isPresented: self.$isShowingImagePicker, user: user)
                    })
            } else {
                Spinner()
                    .frame(width: 200, height: 200)
            }
                
            VStack(spacing: 5) {
                Text(lang["email"] ?? "Email").font(.caption)
                Text(user.value?.mail ?? "не авторизован")
                    .font(.caption)
            }.padding(.vertical, 10)

            
            Group {
                
                
                Button(action: {
                    withAnimation(.default) {
                        Bar.views["mainView"] = Bar.views["orders"]
                        self.mark = .orders
                        self.show.toggle()
                    }
                }) {
                    HStack(spacing: 22) {
                        Image(systemName: "bag.circle")
                            .frame(width: 20.0)
                            .font(.title)
                            .foregroundColor(Color.green)
                        Text(lang["orders"] ?? "Orders")
                        Spacer()
                    }
                }
                
                
                Button(action: {
                    withAnimation(.default) {
                        Bar.views["mainView"] = Bar.views["points"]
                        self.mark = .points
                        self.show.toggle()
                    }
                }) {
                    HStack(spacing: 22) {
                        Image(systemName: "banknote")
                            .frame(width: 20.0)
                            .font(.title3)
                            .foregroundColor(Color.green)
                        Text(lang["points"] ?? "My points")
                        Spacer()
                    }
                }
                .padding(.top, 1.0)
                
                Button(action: {
                    withAnimation(.default) {
                        Bar.views["mainView"] = Bar.views["support"]
                        self.mark = .support
                        self.show.toggle()
                    }
                }) {
                    HStack(spacing: 22) {
                        Image(systemName: "message")
                            .frame(width: 20.0)
                            .font(.title3)
                            .foregroundColor(Color.green)
                        Text(lang["support"] ?? "Support")
                        Spacer()
                    }
                }
                .padding(.top, 1.0)
                
                Divider()
                
                Button(action: {
                    withAnimation(.default) {
                        Bar.views["mainView"] = Bar.views["profile"]
                        self.mark = .profile
                        self.show.toggle()
                    }
                }) {
                    HStack(spacing: 22) {
                        Image(systemName: "person.circle")
                            .frame(width: 20.0)
                            .font(.title3)
                            .foregroundColor(Color.accentColor)
                        Text(lang["profile"] ?? "Profile")
                        Spacer()
                    }
                }
                
                Button(action: {
                    withAnimation(.default) {
                        Bar.views["mainView"] = Bar.views["address"]
                        self.mark = .address
                        self.show.toggle()
                    }
                }) {
                    HStack(spacing: 22) {
                        Image(systemName: "map")
                            .frame(width: 20.0)
                            .font(.title3)
                            .foregroundColor(Color.accentColor)
                        Text(lang["address"] ?? "Address")
                        Spacer()
                    }
                }
                .padding(.top, 1.0)
                
                Divider()
                
                Button(action: {
                    self.dark.toggle()
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    let window = windowScene?.windows.first
                    window?.rootViewController?.view.overrideUserInterfaceStyle = self.dark ? .dark : .light
                }) {
                    
                    HStack {
                        Image(systemName: "moon.fill")
                            .frame(width: 20.0)
                            .font(.title3)
                        Text(lang["darkMode"] ?? "Theme")
                            .padding(.leading, 12.0)

                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .padding(.trailing)
                            .font(.title)
                        //.rotationEffect(.init(degrees: self.dark ? 180 : 0))
                    }
                }
                
                Button(action: {
                    withAnimation(.default) {
                        Bar.views["mainView"] = Bar.views["delete"]
                        self.mark = .delete
                        self.show.toggle()
                    }
                }) {
                    HStack(spacing: 22) {
                        Image(systemName: "person.badge.minus")
                            .frame(width: 20.0)
                            .font(.title3)
                            .foregroundColor(Color.red)
                        Text(lang["deleteAccount"] ?? "Delete Account")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                .padding(.top, 1.0)
                
                Button(action: {
                    Auth().logout() {
                        self.showLoginView = true
                    }
                }) {
                    HStack(spacing: 22) {
                        Image(systemName: "arrow.uturn.backward.square")
                            .frame(width: 20.0)
                            .font(.title3)
                            .foregroundColor(Color.red)
                        Text(logout).foregroundColor(.red)
                        Spacer()
                    }
                }
                .padding(.top, 1.0)
                
            }
            
            Spacer()
            
        }
        .onAppear {
            user.get() {
                print("userExist: \(String(describing: user.value?.userExist))")
            }
        }
        .foregroundColor(.primary)
        .padding([.leading, .trailing], 20)
        
        
    }
    
    


    
    
}

struct Menu_Previews: PreviewProvider {
    
    @StateObject var notification: NotificationLabel = NotificationLabel()
    @State var showLoginView: Bool = false
    
    static var previews: some View {
        Menu(mark: Bar().$mark, showLoginView: Self().$showLoginView, dark: Bar().$dark, show: Bar().$showBar, notification: Self().notification)
            .environmentObject(Load<User>("/api/users/getUserPublic"))
        
        
        // Мало ли пригодится
        VStack {
            
            Image(systemName: "hand.point.left.fill")
                .resizable()
                .frame(width: 30, height: 27)
                .foregroundColor(.red)
            Text("Go Autorisation")
            
        }
    }
}
