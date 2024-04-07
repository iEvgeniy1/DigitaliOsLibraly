
//  Created by EVGENIY DAN on 07.08.2021.
import Foundation

struct ShoppingCart: Codable {
    
    let productId: String
    let row: Int
    let count: String
    var description: String
    let photo: String
    var price: Float
    let h1: String
    let announcement: String
    
    let url: String
    
//    var objectHeight: String
//    var objectDepth: String
//    var objectWidth: String
//    var objectWeight: String
    
    init() {
        self.productId = "123456789"
        self.row = 1
        self.count = "3"
        self.description = "Any usefull information like color and size"
        self.photo = "/images/cms/data/byusti/Gaia/bezymyannyj43.png"
        self.h1 = "Super product, it's the best in the world"
        self.announcement = "Бюстгальтер супер классные"
        
//        self.objectHeight = "10"
//        self.objectDepth = "20"
//        self.objectWidth = "30"
//        self.objectWeight = "200"
        self.url = "/api/p/-bez-mat-internet-magazin-iskusenie"
        self.price = 3500
    }
    
    enum CodingKeys: String, CodingKey {
        case productId
        case row
        case count
        case description
        case photo
        case price
        case h1
        case announcement
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productId = try container.decode(String.self, forKey: .productId)
        self.row = try container.decode(Int.self, forKey: .row)
        self.count = try container.decode(String.self, forKey: .count)
        self.description = try container.decode(String.self, forKey: .description)
        self.photo = try container.decode(String.self, forKey: .photo)
        let price = try container.decode(Float.self, forKey: .price)
        self.price = round(price * 100) / 100
        self.h1 = try container.decode(String.self, forKey: .h1)
        self.announcement = try container.decode(String.self, forKey: .announcement)
        self.url = try container.decode(String.self, forKey: .url)
    }
    
}


