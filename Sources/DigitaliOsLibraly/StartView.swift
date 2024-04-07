//
//  StartView.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 01.03.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import SwiftUI

extension Color {
    static let yellowSet            = Color("yellowSet")
    static let textWhiteDarkSet     = Color("textWhiteDarkSet")
    static let textDarkWhiteSet     = Color("textDarkWhiteSet")
    static let backgroundCard       = Color("backgroundCard")
    static let textCard             = Color("textCard")
    static let shadowCard           = Color("shadowCard")
    static let backgroundSection    = Color("backgroundSection")
    static let shoppingCartEmpty    = Color("shoppingCartEmpty")
}

var mainHost: String = "https://prstar.ru"

//import SwiftUI
//
//
//
//public struct StartView: View {
//    
//    public init() { }
//    
//    @StateObject var session = Load<String>("/api/login/")
//    
//    @Environment(\.managedObjectContext) var managedObjectContext
//    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var database: FetchedResults<Item>
//    
////    @StateObject var companies = Load<Company>("/api/company/userCompanies")
//    
//    @State var showEditMyBusinessView = false // компанию нужно дорегистрировать, она уже создана
//    
//    @State var loadingLanguagies: Bool = true
//    
//    public var body: some View {
//        
//        VStack {
//            if loadingLanguagies {
//                Spinner(style: .large)
//            } else {
//                Bar()
//            }
//        }
//        .keyboardResponsive()
//        .onAppear {
//            setSession()
//            setLanguage()
//        }
//    }
//    
//    
//    func setSession() {
//        if Auth().session == nil {
//            session.path = "/api/login/"
//            session.get() { responce in
//                switch responce {
//                case .failure:
//                    print("error session: failure")
//                case .successArray(_):
//                    print("error session: we get array")
//                case .successOne(let session):
//                    print("success get session: \(String(describing: session))")
//                    Auth().session = session
//                }
//            }
//        } else {
//            print("session != nil: \(String(describing: Auth().session))")
//        }
//    }
//    
//    
//    func setLanguage() {
//        // Внимание! Язык сбрасывается при каждой загрузки приложения.
//        
////        if let translateFirst = lang.first {
////            loading = false
////            print("we have loaded language exemple: \(String(describing: translateFirst.policy2))")
////            print("we have loaded language exemple: \(String(describing: translateFirst.together))")
////        } else {
//        
//        ///  Define language
//        let locale = NSLocale.preferredLanguages.first // "ru-RU"
//        
//        var langCode: String {
//            if let code = locale?.components(separatedBy: "-").first {
//                if code == "ru" {
//                    return ""
//                } else {
//                    return "/" + code
//                }
//            } else {
//                print("Error define language")
//                return ""
//            }
//        }
//        print("LANGUAGE_DEFAULT – \(langCode)")
//        
//        let loadLanguage = Load<[String:String]>("\(langCode)/api/allTranslate/")
//        loadLanguage.get() { response in
//            switch response {
//                
//            case .failure:
//                print("Ошибка. Загружаем переводы из хранилища, если там что-то уже есть")
//                loadingLanguagies = false
//            case .successOne(let translate):
//                lang = translate
////                Language.saveDictionaries(dic: translate, managedObjectContext: managedObjectContext, coreData: database)
//                print("translate from server count: \(translate)")
//                loadingLanguagies = false
//            case .successArray(_):
//                print("почему-то пришел массив")
//                loadingLanguagies = false
//            }
//        }
//    }
//    
//}
//
//struct StartView_Previews: PreviewProvider {
//    @StateObject var session = Load<String>("/api/login/")
//    init() {
//        session.path = "/api/login/"
//        session.get() { responce in
//            switch responce {
//            case .failure:
//                print("error: failure")
//            case .successArray(_):
//                print("error: we get array")
//            case .successOne(let session):
//                print("success get session: \(String(describing: session))")
//                Auth().session = session
//            }
//        }
//    }
//    static var previews: some View {
////        StartView(session: Self().session)
//        StartView()
//    }
//}
