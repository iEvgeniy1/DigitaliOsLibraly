//
//  ProductExtra.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 19.03.2022.
//

import Foundation

final class ProductExtra: Codable, Identifiable {
    
    var id: UUID?
    var product: Product?
    var extraName: String
    var value: String

    init(
        product: Product,
        extraName: String,
        value: String
    ) {
        self.product = product
        self.extraName = extraName
        self.value = value
    }
    
}
