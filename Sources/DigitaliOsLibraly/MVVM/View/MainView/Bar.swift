//
//  BarButtonMenu.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 15.01.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//


import SwiftUI
import Foundation

enum ShowView: Equatable {
    
    case catalog
    case list
    case shoppingcart
    case orders
    case points
    case support
    case delete
    case profile
    case address
    case accountDetails
    
}

public struct Bar : View {
    
    public init() { }
    
    @State var mark: ShowView = .catalog
    
    static var views: [String:AnyView] = ["catalog":AnyView(ProductShownView()), "list":AnyView(LoadListView()), "shoppingcart":AnyView(LoadShoppingcartView()), "orders":AnyView(LoadOrdersView()), "points":AnyView(LoadPointsView()), "support":AnyView(LoadSupporView()), "delete":AnyView(LoadDeleteView()), "profile":AnyView(LoadProfileView()), "address":AnyView(LoadAddressView()),  "mainView":AnyView(Text("Loading..."))] //AnyView(Text("Loading..."))

    static var catalogView: ProductShownView = .init()
    
    @State var dark = false
    @State var showBar = false
    @State var tapFlag = false
    
    @State var showPopUp = false
    
    @StateObject var notification: NotificationLabel = NotificationLabel()
    
    public var body: some View {
        
        ZStack(alignment: .leading) { // или меню не будет доходить до конца левого края
            
            VStack(spacing: 0) {
                
//                Spacer() // нужно прижать TabBar к низу
                
                ZStack {
                    ProductShownView()
                        
                    if showPopUp {
                        ScrollView {
                            EmptyView()
                                .frame(width: UIScreen.main.bounds.width,
                                       height: UIScreen.main.bounds.height)
                                .background(Color.textWhiteDarkSet)
                        }
                        Self.views["mainView"]
                    }
                }
                .padding(.top, 10.0)
                
                HStack(spacing: 0) {
                    
                    
                    Button(action: {
                        if notification.newProducts != "" {
                            notification.newProducts = ""
//                                Load<Company>("/api/company/clean/newCompanies").patch()
                        }
                        Self.views["mainView"] = Self.views["catalog"]
                        self.mark = .catalog
                        showPopUp = false
                    }) {
                        VStack{
                            ZStack {
                                Image(systemName: "cursor.rays").resizable().frame(width: 25, height: 25)
                                    .scaleEffect(.init(self.mark == .catalog ? 1.2 : 1))
                                NotificationView(notification: $notification.newProducts)
                            }
                            Text(lang["catalog"] ?? "Catalog").font(.caption)
                        }.foregroundColor(self.mark == .catalog ? Color.green : Color.black)
                    }
                    
                    Spacer()
                    Button(action: {
                        withAnimation(.default) {
                            Self.views["mainView"] = Self.views["list"]
                            self.mark = .list
                            showPopUp = true
                        }
                    }) {
                        VStack{
                            ZStack {
                                Image(systemName: "arrow.clockwise.heart").resizable().frame(width: 30, height: 25)
                                    .rotationEffect(.init(degrees: self.mark == .list ? 180 : 0))
                                NotificationView(notification: $notification.wishlist)
                            }
                            Text(lang["list"] ?? "List").font(.caption)
                        }.foregroundColor(self.mark == .list ? Color.green : Color.black)
                    }
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("needRenewWishlist"))) { _ in
                        notification.needRenewWishlist()
                    }
                    
                    
                    Spacer()
                    Button(action: {
                        withAnimation(.default) {
                            Self.views["mainView"] = Self.views["shoppingcart"]
                            self.mark = .shoppingcart
                            showPopUp = true
                        }
                    }) {
                        VStack{
                            ZStack {
                                Image(systemName: "cart").resizable().frame(width: 25, height: 25)
                                    .scaleEffect(.init(self.mark == .shoppingcart ? 1.2 : 1))
                                NotificationView(notification: $notification.shoppingcart)
                            }
                            Text(lang["shoppingcart"] ?? "Shopping cart").font(.caption)
                        }.foregroundColor(self.mark == .shoppingcart ? Color.green : Color.black)
                    }
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("needRenewShoppingCart"))) { _ in
                        notification.needRenewShoppingCart()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("setZeroInCart"))) { _ in
                        print("setZeroInCart")
                        notification.shoppingcart = ""
                    }
                    
                    Spacer()
                    Button(action: {
                        withAnimation(.default) {
                            self.showBar.toggle()
                        }
                    }) {
                        VStack{
                            ZStack {
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .rotationEffect(.init(degrees: self.showBar ? 90 : 0))
                                NotificationView(notification: $notification.cabinet)
                            }
                            Text(lang["cabinet"] ?? "Cabinet").font(.caption)
                        }.foregroundColor(self.showBar ? Color.green : Color.black)
                    }
                    .padding(.trailing)
                }
                .padding(.top, 10.0)
                .padding(.horizontal, 15.0)
                .padding(.bottom, 18.0)
                .background(Color(#colorLiteral(red: 0.7490096688, green: 0.7490096688, blue: 0.7490096688, alpha: 0.9693551937)))
            }
            .edgesIgnoringSafeArea(.bottom)
//            .ignoresSafeArea()
            
            HStack{

                CabinetOrLoginView(notification: self.notification,
                                   mark: self.$mark,
                                   dark: self.$dark,
                                   show: self.$showBar)
                    //.preferredColorScheme(self.dark ? .dark : .light)
                    .offset(x: self.showBar ? UIScreen.main.bounds.width / 6 : UIScreen.main.bounds.width / 1.005)
                    
                //Spacer(minLength: 0) // оттолкнет Menu от правого края

            }
            .background(self.showBar ? Color.primary.opacity(self.dark ? 0.5 : 0.2) : Color.clear).edgesIgnoringSafeArea(.all)
            
        }
        .preferredColorScheme(self.dark ? .dark : .light)
        .onAppear {
            Self.views["mainView"] = Self.views["catalog"]
            setNotification()
//            self.view = AnyView(ShownView(showView: $mark))
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("setNotificationFromAppDelegate"))) { notification in
            setNotification()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("showOrders"))) { notification in
            withAnimation(.default) {
//                self.showBar.toggle()
                self.mark = .orders
                Self.views["mainView"] = Self.views["orders"]
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("showPopUp"))) { notification in
            showPopUp = true
        }
        
    }
    
    private func setView(_ view: String) {
        
    }
    
    private func setNotification() {
//        let mainCompnay = Load<Company>("/api/company/mainCompany")
//        mainCompnay.get() {
//            notification.setNotification(mainCompnay.value)
//        }
        print("Нужно настроить")
    }
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Bar()
//            .environmentObject(Load<User>("/api/users/getUserPublic"))
    }
}

