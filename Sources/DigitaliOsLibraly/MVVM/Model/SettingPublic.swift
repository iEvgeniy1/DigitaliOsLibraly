//
//  Setting.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 24.04.2022.
//

import Foundation

struct SettingPublic: Codable {
    
    var googleMapAddresses: String?
    var googleMapKey: String?
    var addressSender: String?
    var returnPoints: Int?
    var mobilDelivery: Bool?
    var mobilDirectories: String?
    
    internal init(googleMapAddresses: String? = nil,
                  googleMapKey: String? = nil,
                  addressSender: String? = nil
    ) {
        self.googleMapAddresses = googleMapAddresses
        self.googleMapKey = googleMapKey
        self.addressSender = addressSender
    }
    
}
