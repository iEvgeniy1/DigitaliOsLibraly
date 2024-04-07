//
//  File.swift
//  
//
//  Created by EVGENIY DAN on 27.06.2021.
//

import Foundation

final class Visitor: Codable, Identifiable {
    
    var id: UUID?
    var session: String?
    var productIdAndCount: [String:String]?
    var user: User?
    
    // Для админки
    var date: Date?
    var statusShoppingCart: StatusShoppingCart
    // Только для context в базе данные пока не храню
    var shoppingCart_id: [ShoppingCart]?
    var sumInShoppingCart: Int?
    
    init(session: String?,
         productIdAndCount: [String:String]?,
         date: Date,
         statusShoppingCart: StatusShoppingCart
    ) {
        self.session = session
        self.productIdAndCount = productIdAndCount
        self.date = date
        self.statusShoppingCart = statusShoppingCart
    }
    
}


enum StatusShoppingCart: String, Codable, CaseIterable {
    case empty
    case justAdded
    case shoppingCart
    case delivery
    case payment
    case review
    
    func convertToCollor() -> String {
        switch self {
        case .empty: return "danger"
        case .justAdded: return "warning"
        case .shoppingCart: return "info"
        case .delivery: return "primary"
        case .payment: return "success"
        case .review: return "dark"
        }
    }
    
    func convertToIcon() -> String {
        switch self {
        case .empty: return "mdi-gauge-empty"
        case .justAdded: return "mdi-timer-sand"
        case .shoppingCart: return "mdi-square-edit-outline"
        case .delivery: return "mdi-dump-truck"
        case .payment: return "mdi-cash"
        case .review: return "mdi-eye"
        }
    }
   
}
