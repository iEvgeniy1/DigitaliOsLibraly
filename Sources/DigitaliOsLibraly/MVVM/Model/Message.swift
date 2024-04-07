//
//  Message.swift
//  App
//
//  Created by EVGENIY DANILOV on 23.04.2020.
//
import Foundation

final class Message: Codable, Identifiable {

    var id: UUID?
    var auth: User?
    var recip: User?
    
    var read: Int?
    var time: String
    var message: String
    
    var name: String?
    var picture: String?
    
    init(message: String) {
        self.read = 1
        self.time = DateFormat().convertToString(date: Date(), dateformat: .date)
        self.message = message
    }
    
    convenience init(authIsMe: Bool) {
        
        self.init(message: "I am writing this post on a hot day. Imagine still spring, not even the month of May, but already warm! I sunbathed and swam in the pool. And I thought what country is the best in the world. And this is not an easy question as it seems to you ...")
        self.auth = User(userExist: true)
        self.recip = User(userExist: true)
        
        // If I isn't auth this message, thet mean auth must have other UUID
        if !authIsMe {
            self.auth?.id = UUID()
        }
        
        self.name = "Dandy"
        self.picture = "noImage"
    }

}




