//
//  Product.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 19.03.2022.
//

import Foundation

struct Product: Codable {
    
    var int: [String:Int] = .init()
    var double: [String:Double] = .init()
    var value: [String:String] = .init()
    var array: [String:[String]] = .init()
    
    internal init(id: UUID? = .init(), int: [String : Int] = .init(), double: [String : Double] = .init(), value: [String : String] = .init(), array: [String : [String]] = .init(), dic: [String : [Dictionaries]] = .init()) {
        self.int = int
        self.double = double
        self.value = value
        self.array = array
    }
    
    init() {
        let announcement = "Бюстгальтер супер классные"
        let description = "<p>&nbsp;Бюстгальтер типа минимайзер на тонком поролон. Чашка покрыта цветочным кружевом. Для лучшей поддержки имеет боковую косточку.&nbsp;</p>"
        var optionalImages: [String] = repeatElement("/images/cms/data/byusti/Gaia/bezymyannyj43.png", count: 10).reversed()
        optionalImages += repeatElement("/images/mat/3045.jpg", count: 10).reversed()
        
        self.value["type_id"] = "123"
        self.value["is_active"] = "1"
        self.value["parent_id"] = "type_id"
        self.value["h1"] = "Super product, it's the best in the world"
        self.value["artikul"] = "1235621"
        self.value["metaTitle"] = "Cool company"
        self.value["metaDescriptions"] = "We are the best!"
        self.value["metaKeywords"] = "product, good product"
        self.value["photo"] = "/images/cms/data/byusti/Gaia/bezymyannyj43.png"
        self.value["announcement"] = announcement
        self.value["description"] = description
        self.value["price"] = "100"
        self.value["objectWeight"] = "12"
        self.array["optionalImages"] = optionalImages
        self.value["url"] = "/product"
        
        self.array["sizes"] = ["48", "50", "52", "54"]
        self.array["colors"] = ["синий", "красный", "желтый", "белый"]
    }
    
}


struct Dictionaries: Codable {
    
    var key: String? // now -> h1
    var value: String? // now -> description
    var h1: String
    var description: String
    
    internal init(h1: String, description: String) {
        self.h1 = h1
        self.description = description
    }
    
    enum CodingKeys: String, CodingKey {
        case key
        case value
        case h1
        case description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let key = try? container.decode(String?.self, forKey: .key) {
            self.h1 = key
        } else {
            self.h1 = try container.decode(String.self, forKey: .h1)
        }
        if let value = try? container.decode(String?.self, forKey: .value) {
            self.description = value
        } else {
            self.description = try container.decode(String.self, forKey: .description)
        }
    }
    
}
