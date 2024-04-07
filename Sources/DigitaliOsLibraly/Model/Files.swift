//
//  File.swift
//  
//
//  Created by EVGENIY DAN on 23.09.2021.
//

import Foundation

final class Files: Codable, Identifiable {
    
    var id: UUID?
    var name: String
    var size: String
    var type: String?
    var path: String?
    var order: Order
    
    init(
        name: String,
        size: String,
        type: String,
        path: String,
        order: Order
    ) {
        self.name = name
        self.size = size
        self.type = type
        self.path = path
        self.order = order
    }
    
}
