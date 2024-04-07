//
//  Language.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 28.02.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

struct Languagies: Codable {
    var languagies: [String]
}
//
//struct Language: Codable {
//    
//    var dic: Data?
//    
//    static func saveDictionaries(dic: [String:String],
//                                 managedObjectContext: NSManagedObjectContext,
//                                 coreData: FetchedResults<Item>) {
//        
//        Self.deleteContext(managedObjectContext, coreData)
//        
//        let context = Item(context: managedObjectContext)
//            
//        do {
//            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: dic, requiringSecureCoding: false)
//            context.dic = encodedData
//            print("befor save context:")
//            try managedObjectContext.save()
//        } catch {
//            print("Error saving managed object context: \(error)")
//        }
//        
//    }
//    
//    static func deleteContext(_ managedObjectContext: NSManagedObjectContext, _ coreData: FetchedResults<Item>) {
//        for index in 0..<coreData.count {
//            let deleteData = coreData[index]
//            managedObjectContext.delete(deleteData)
//        }
//        do {
//            try managedObjectContext.save()
//        } catch {
//            print("Error saving managed object context: \(error)")
//        }
//    }
//    
//}
