//
//  File.swift
//  
//
//  Created by EVGENIY DAN on 22.07.2021.
//
import Foundation

final class Order: Codable, Identifiable {

    var id: UUID?
    
    var name: String?
    var phone: String?
    var mail: String?
    
    var productIdAndCount: [String:String]?
    var numberOrder: Int
    var date: String // нужно ставить datetime
    var sumInShoppingCart: Int
    var sumTotal: Int
    
    var comment: String?
    
    var needDelivery: Bool?
    var deliveryCost: Int
    var trackerDelivery: String?
    var wantUsePoints: Bool?
    var points: Int
    
    var cargoType: String?
    var country: String?
    var city: String?
    var address: String?
    
    var nameBusiness: String?
    var inn: String?
    var kpp: String?
    
    var paymentStatus: PaymentStatus
    var orderStatus: OrderStatus
    var paymentMethod: PaymentMethod
    
    var user: User?
    var files: [Files]? = []
    
    init(number: Int,
         sum: Int,
         sumTotal: Int,
         _ productIdAndCount: [String:String]?,
         _ user: User,
         needDelivery: Bool?,
         paymentStatus: PaymentStatus?,
         orderStatus: OrderStatus?,
         tracker: String? = nil,
         paymentMethod: PaymentMethod?,
         wantUsePoints: Bool,
         points: Int
    ) {
        
        self.name = user.name
        self.phone = user.phone
        self.mail = user.mail
        
        self.productIdAndCount = productIdAndCount
        self.numberOrder = number
        self.date = DateFormat().convertToString(date: Date(), dateformat: .date)
        self.sumInShoppingCart = sum
        
        self.sumTotal = sumTotal
        self.wantUsePoints = wantUsePoints
        self.points = points//sumTotal / 100 * pointsReturn
        
        self.comment = user.comment
        
        self.needDelivery = needDelivery ?? user.needDelivery
        self.deliveryCost = user.deliveryCost ?? 0
        self.trackerDelivery = tracker
        self.cargoType = user.cargoType
        
        self.country = user.country
        self.city = user.city
        self.address = user.address
        
        self.nameBusiness = user.nameBusiness
        self.inn = user.inn
        self.kpp = user.kpp
        
        self.paymentStatus = paymentStatus ?? .awaitingPayment
        self.orderStatus = orderStatus ?? .inProcess
        self.paymentMethod = paymentMethod ?? .invoice
        
        self.user = user
        
    }
    
    convenience init(test: Bool) {
        self.init(number: 5253,
                  sum: 2500,
                  sumTotal: 3000025,
                  nil,
                  User(userExist: false),
                  needDelivery: true,
                  paymentStatus: .awaitingPayment,
                  orderStatus: .inProcess,
                  tracker: nil,
                  paymentMethod: .cash,
                  wantUsePoints: true,
                  points: 25)
    }
    
}

enum OrderStatus: String, Codable, CaseIterable {
    
    case inProcess //= "Распределение"
    case newLead //= "Новый лид"
    case inProgress //= "Взят в работу"
    case missCall //= "Недозвон"
    case needInformation //= "Недостаточно информации"
    case longInterest //= "Долгосрочный интерес"
    case preparationProposal //= "Подготовка КП"
    case proposalSent //= "Предложение отправлено"
    case newProposal //= "Ознакомлен с предложением"
    case preparationContract //= "Подготовка договора/счета"
    case production //= "В производстве"
    case preparationShipment //= "Подготовка к отгрузке"
    case shipment //= "Доставка/самовывоз"
    case awaitingDocuments //= "Ждем документы"
    case delivered //= "Успешно реализовано"
    case canceled //= "Закрыто и не раализовано"
    
    func convertToCollor() -> String {
        switch self {
        case .inProcess : return "secondary"
        case .newLead: return "secondary"
        case .inProgress: return "secondary"
            
        case .missCall: return "warning"
        case .needInformation: return "warning"
        case .longInterest: return "dark"
        case .preparationProposal: return "info"
        case .proposalSent: return "info"
        case .newProposal: return "info"
        case .preparationContract: return "info"
        case .production: return "primary"
        case .preparationShipment: return "primary"
        case .shipment: return "primary"
        case .awaitingDocuments: return "warning"
        case .delivered: return "success"
        case .canceled: return "danger"
        }
    }
    
    func translate() -> String {
        switch self {
        case .inProcess: return "Распределение"
        case .newLead: return "Новый лид"
        case .inProgress: return "Взят в работу"
        case .missCall: return "Недозвон"
        case .needInformation: return "Недостаточно информации"
        case .longInterest: return "Долгосрочный интерес"
        case .preparationProposal: return "Подготовка КП"
        case .proposalSent: return "Предложение отправлено"
        case .newProposal: return "Ознакомлен с предложением"
        case .preparationContract: return "Подготовка договора/счета"
        case .production: return "В производстве"
        case .preparationShipment: return "Подготовка к отгрузке"
        case .shipment: return "Доставка/самовывоз"
        case .awaitingDocuments: return "Ждем документы"
        case .delivered: return "Успешно реализовано"
        case .canceled: return "Закрыто и не раализовано"
        }
    }
}


enum PaymentStatus: String, Codable, CaseIterable {
    
    case paid //= "Оплачен"
    case awaitingPayment //= "Ожидаем оплату"
    case awaitingFullPayment //= "Ждем полную оплату"
    case cachOnDelivery //= "Оплата при получении"
    case unpaid //= "Не оплачен"
    case paymentFailed //= "Платеж не прошел"
    case canceled //= "Отменен"
    
    func convertToCollor() -> String {
        switch self {
        case .paid: return "success"
        case .awaitingPayment: return "info"
        case .awaitingFullPayment: return "warning"
        case .cachOnDelivery: return "primary"
        case .unpaid: return "dark"
        case .paymentFailed: return "danger"
        case .canceled: return "danger"
        }
    }
    func translate() -> String {
        switch self {
        case .paid: return "Оплачен"
        case .awaitingPayment: return "Ожидаем оплату"
        case .awaitingFullPayment: return "Ждем полную оплату"
        case .cachOnDelivery: return "Оплата при получении"
        case .unpaid: return "Не оплачен"
        case .paymentFailed: return "Платеж не прошел"
        case .canceled: return "Отменен"
        }
    }
    func convertToClassName() -> String {
        switch self {
        case .paid: return "bigNumberPlus"
        case .awaitingPayment: return "bigNumberAwaitingPayment"
        case .awaitingFullPayment: return "bigNumberAwaitingPayment"
        case .cachOnDelivery: return "bigNumberAwaitingPayment"
        case .unpaid: return "bigNumberCancel"
        case .paymentFailed: return "bigNumberCancel"
        case .canceled: return "bigNumberCancel"
        }
    }
    func translateForPoint() -> String {
        switch self {
        case .paid: return "С заказа начислено баллов"
        case .awaitingPayment: return "Ожидаем оплату"
        case .awaitingFullPayment: return "Ждем полную оплату и быллы будут начислены"
        case .cachOnDelivery: return "После оплаты при получении будут начислены баллы"
        case .unpaid: return "Не оплачен, баллы не начислены"
        case .paymentFailed: return "Платеж не прошел, баллы не начислены"
        case .canceled: return "Отменен, баллы не начислены"
        }
    }
}
