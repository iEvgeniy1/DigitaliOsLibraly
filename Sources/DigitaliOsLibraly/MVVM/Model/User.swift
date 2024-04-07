/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

final class User: Codable, Identifiable {
    
    var id: UUID?
    var name: String?
    var surname: String?
    var mail: String?
    var phone: String?

    var userType: UserType?
    
    var picture: String?
    var deletedAt: Date?
    var lang: String?
    var balance: Int?
    var appleId: String?
//    var createDate: String?
    
    var visitor: Visitor?
    var orders: [Order]?
    
    var wantEdit: Bool?
    
    var comment: String?

    var needDelivery: Bool?
    var deliveryCost: Int?
    var wantUsePoints: Bool?
    var canUsePoints: Int?
    var counPointsTotal: Int?
    
    var cargoType: String?
    var country: String?
    var city: String?
    var address: String?

    var nameBusiness: String?
    var inn: String?
    var kpp: String?

    var thisOrderIsntCreated: Bool?
    var mailAboutRegistration: Bool?
    
    var lastMessage: String?
//    var lastMessageDate: String?
    var messageUnread: Int?
    
    var userExist: Bool?
    
    
    
    var session: String? // need only for post request
    var password: String? // need for change password only
    var pictureData: Data? // need for change frofile only
    
    var user: User? // need for decode
    var statusShoppingCart: String? // need for decode
    var loginCondition: String? // need for decode
    
    static var defaultImagies: String {
        let imagies =
        [
            "/img/defaultAvatars/avatar1.png",
            "/img/defaultAvatars/avatar2.png",
            "/img/defaultAvatars/avatar3.png",
            "/img/defaultAvatars/avatar4.png",
            "/img/defaultAvatars/avatar5.png",
            "/img/defaultAvatars/avatar6.png",
            "/img/defaultAvatars/avatar7.png",
            "/img/defaultAvatars/avatar8.png",
            "/img/defaultAvatars/avatar9.png"
        ]
        return imagies[Int.random(in: 0...8)]
    }
    
    convenience init(userExist: Bool) {
        self.init()
        self.userExist = userExist
        if userExist {
            id = UUID(uuidString: "123e4567-e89b-12d3-a456-426655440000")
        }
    }

}

enum UserType: String, Codable {
    case admin
    case adminHelper
    case worker
    case customerWithoutPassword
    case customer
    case unknown
}

// Внимание! Не использую нужно переделать для отправки регистрации пользователя
struct RegisterUser: Codable {
    
    var name: String?
    var password: String?
    var confirmPassword: String?
    var mail: String?
    var phone: String?
    
    var loginCondition: LoginCondition?
    var inputMailAndPassword: InputMailAndPassword?
    var user: User?
    
}

enum LoginCondition: String, Codable {
    case mailIsntExist      //"This mail is exist already"
    case passwordError      //"Password is wrong"
    case getParametersError //"Problem with get parameters"
    case mailIsBusy         //"User with this mail allready exist"
    case mailForbidden      //"The mail isn't exist"
    case mailWasFree        //"The mail is free"
    case mailNowAuth           //"The mail now auth"
    case enumAllCases = "'mailIsntExist' or 'passwordError' or 'getParametersError' or 'mailIsBusy' or 'mailForbidden' or 'mailWasFree' or 'mailNowAuth'"
}

struct InputMailAndPassword: Codable {
    let mail: String
    let password: String
    let name: String?
    let phone: String?
}

enum PaymentMethod: String, Codable, LosslessStringConvertible {
    
    case unowned
    case cash //="Наличные"
    case invoice //="Банковский платеж"
    case card //="Карта"
    
    func translate() -> String {
        switch self {
        case .unowned: return "Неопределен"
        case .cash: return "Наличные"
        case .invoice: return "Банковский платеж"
        case .card: return "Карта"
        }
    }
    
    // For `LosslessStringConvertible`. Нужно чтобы parameters приводить к enum
    var description: String { self.rawValue }
    public init?(_ description: String) {
        self.init(rawValue: description)
    }
    
}

