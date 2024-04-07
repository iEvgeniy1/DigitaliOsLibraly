//
//  NotificationLabel.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 04.04.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import Foundation

class NotificationLabel: ObservableObject {
    
    @Published var newProducts: String = ""
    @Published var wishlist: String = ""
    @Published var shoppingcart: String = ""
    @Published var cabinet: String = ""
    
    @Published var orders: String = ""
    @Published var points: String = ""
    @Published var messagies: String = ""
    @Published var profile: String = ""
    @Published var address: String = ""
    
    init() {
        needRenewWishlist()
        needRenewShoppingCart()
    }
    
    func needRenewWishlist() {
        let wishlistLoad: Load<ShoppingCart> = .init("/api/renewWishlist/")
        wishlistLoad.get() {
            let countWishlist = wishlistLoad.elements.count
            let countString = countWishlist == 0 ? "" : String(countWishlist)
            DispatchQueue.main.async { [self] in
                self.wishlist = countString
            }
        }
    }
    
    func needRenewShoppingCart() {
        let shoppingcartLoad: Load<ShoppingCart> = .init("/api/renewShoppingCart/")
        shoppingcartLoad.get() {
            let countShoppingcart = shoppingcartLoad.elements.count
            let countString = countShoppingcart == 0 ? "" : String(countShoppingcart)
            DispatchQueue.main.async { [self] in
                self.shoppingcart = countString
            }
        }
    }
    
    
    
    
    func setNotification() {
        
//        self.company = company
//        if let company = company {
//            let sumMenuNotification = (company.messagies ?? 0) + (company.helpCenterMessagies ?? 0) + (company.tasks ?? 0)
//            DispatchQueue.main.async { [self] in
//                self.messagies = String(company.messagies ?? 0) == "0" ? "" : String(company.messagies ?? 0)
//                self.tasks = String(company.tasks ?? 0) == "0" ? "" : String(company.tasks ?? 0)
//
//                self.circleCounts = String(company.circleCounts ?? 0) == "0" ? "" : String(company.circleCounts ?? 0)
//                self.chooseMeCounts = String(company.chooseMeCounts ?? 0) == "0" ? "" : String(company.chooseMeCounts ?? 0)
//                self.chooseTogetherCounts = String(company.chooseTogetherCounts ?? 0) == "0" ? "" : String(company.chooseTogetherCounts ?? 0)
//
//                self.helpCenterMessagies = String(company.helpCenterMessagies ?? 0) == "0" ? "" : String(company.helpCenterMessagies ?? 0)
//                self.transactions = String(company.transactions ?? 0) == "0" ? "" : String(company.transactions ?? 0)
//                self.newCompanies = String(company.newCompanies ?? 0) == "0" ? "" : String(company.newCompanies ?? 0)
//                self.sumMenuNotification = String(sumMenuNotification) == "0" ? "" : String(sumMenuNotification)
//            }
//        } else {
//            print("Error in Notification class, setNotification func - Company is nil")
//        }
        
        print("Нужно настроить")
    }
    
//    func countMenuNotification(value: String) {
//
//        switch value {
//        case "tasks":
//            company?.tasks = 0
//        case "helpCenterMessagies":
//            company?.helpCenterMessagies = 0
//        case "messagies":
//            company?.messagies = 0
//        default:
//            print("Error in Notification countMenuNotification func")
//        }
//
//        guard let company = company else { return }
//
//        let sumMenuNotification = (company.messagies ?? 0) + (company.helpCenterMessagies ?? 0) + (company.tasks ?? 0)
//        self.sumMenuNotification = String(sumMenuNotification) == "0" ? "" : String(sumMenuNotification)
//    }

}
