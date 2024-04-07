//
//  Load.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 27.06.2020.
//  Copyright © 2020 EVGENIY DAN. All rights reserved.
//

import SwiftUI

extension Load where GetType: Codable  {
    
    @inlinable public func post<U>(_ transform: (((GetRequest<GetType>) -> Void)?) throws -> U?) rethrows -> U? {
        return nil
    }
    
}

public var lang: [String:String] = [:]



//func getPath<GetType>(T: GetType) -> String {
//    
//    var path = ""
//    
//    switch T.self {
//    case is User.Type:
//        path = "users"
//    case is Tasks.Type:
//        path = "task"
//    case is TokenSecret.Type:
//        path = "token"
//    case is Company.Type:
//        path = "company"
//    case is Transaction.Type:
//        path = "transaction"
//    case is Message.Type:
//        path = "message"
//    case is RegisterUser.Type:
//        path = "register"
//    case is Data.Type:
//        path = "" // может быть использован для закачки изображания из разных моделей
//        //self.value = UIImage(named: "notAvatar")?.pngData() as? GetType
//        
//    default:
//        path = "default"
//    }
//    return path
//}

// Так как Data (изображения) много весят, то тут они кэшируются. И чтобы их обновить нужно принудительно выставлять ключу словаря значение nil!
var cacheData: [String:Data] = [:]

var mainHost: String = "https://prstar.ru"

public class Load<GetType: Codable>: ObservableObject {
    
    let baseURL = mainHost
    //let baseURL = "https://rasti.herokuapp.com/api/"
    var imagePath: String?
    
    
    @Published var value: GetType? {
        didSet {
//            print("set new value: \(String(describing: value))")
            if value != nil {
                DispatchQueue.main.async { [self] in
                    let idImageString: String = self.idImage != nil ? self.idImage!.description : ""
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.path + idImageString), object: nil)
                }
            }
        }
    }
    
    @Published var elements = [GetType]() {
        didSet {
//            print("send NSNotification - elements get: \(path)")
//            DispatchQueue.main.async { [self] in
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: path), object: nil)
//            }
        }
    }
    
    var usersRequest: Request<GetType>?
    
    public var path: String = ""
    
    public var idImage: UUID?
    
    public init() {
        //self.path = getPath(T: GetType.self)
        print("Load init - empty: \(path), Type: \(GetType.self)")
    }
    
    public init(_ path: String) {
        self.path = path
        print("Load init - path: \(path), self.path:\(self.path), Type: \(GetType.self)")
    }
    
    public init(_ path: String, _ id: UUID) {
        self.path = path
        self.idImage = id
        print("Load init - path and id: \(path), Type: \(GetType.self)")
    }
    
    public init(value: GetType) {
        self.value = value
        print("Load init - value: \(path), Type: \(GetType.self)")
    }
    
    public init(elements: [GetType]) {
        self.elements = elements
        print("Load init - elements: \(path), Type: \(GetType.self)")
    }
    
//    convenience init(path: String, imagePath: String) {
//        self.init()
//        print("convenience init(_ path: \(path), imagePath: \(imagePath) ")
//        self.path = path
//        self.imagePath = imagePath
//    }
    
    public func getDataWithCache() {
    
        if cacheData[path] == nil {
            if self.path != "" {
                usersRequest = Request<GetType>(resourcePath: "\(baseURL + self.path)")
//                usersRequest = Request<GetType>(resourcePath: "\(self.path)")
                usersRequest?.get{ result in
                    
                    switch result {
                    case .failure: print("getImageWithCache() - Data на сервере отсутствует - self.value = nil")
                        if GetType.self is Data.Type {
                            let data = UIImage(systemName: "photo.on.rectangle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemGray, renderingMode: .alwaysOriginal).pngData()
                            cacheData[self.path] = self.value as? Data
                            DispatchQueue.main.sync {
                                self.value = data as? GetType
                            }
                        } else {
                            print("Пришел тип данных не Data: \(GetType.self)")
                        }
                    case .successOne(let value):
                        
                        cacheData[self.path] = value as? Data
                        DispatchQueue.main.sync {
                            self.value = value
                        }
                        
                    case .successArray:
                        print("Пришел массив, которого в этом запросе не предусмотренно!")
                    }
            
                }
            } else {
                self.value = nil

            }
        } else {
            print("Data будет загружено из кэша - GetType: \(GetType.self)")
            self.value = cacheData[path] as? GetType

        }
    }
    
    
//    func get(_ completion: (() -> Void)? = nil) {
//        usersRequest = Request<GetType>(resourcePath: "\(baseURL + self.path)")
//        usersRequest!.get{ result in
//
//            switch result {
//            case .failure:
//                print("get() - There was an error getting the tasks")
//            case .successOne(let value):
//                DispatchQueue.main.sync {
//                    self.value = value
//                }
//                (completion ?? self.complelionBlock)()
//            case .successArray(let elements):
//                print("Пришел массив: path - \(self.path), elements.count(\(elements.count))")
//                DispatchQueue.main.sync {
//                    self.elements = elements
//                }
//                (completion ?? self.complelionBlock)()
//            }
//        }
//    }
    // MARK: GET
    // реализация без complition handler, а если он все же используется, то без "_ in"
    public func get(_ completion: (() -> Void)? = nil) {
        getBody() { _ in
            (completion ?? self.complelionBlock)()
        }
    }
    // реализация cо значением c complition handler
    public func get(_ completion: @escaping (GetRequest<GetType>) -> Void) {
        getBody() { result in
            completion(result)
        }
    }
    
    public func getBody(_ completion: ((GetRequest<GetType>) -> Void)? = nil) {
        usersRequest = Request<GetType>(resourcePath: "\(baseURL + self.path)")
        usersRequest!.get{ result in

            switch result {
            case .failure:
                print("get() - There was an error getting the tasks")
                (completion ?? self.complelionBlock)(result)
            case .successOne(let value):
                DispatchQueue.main.sync {
                    self.value = value
                }
                (completion ?? self.complelionBlock)(result)
            case .successArray(let elements):
                print("Пришел массив: path - \(self.path), elements.count(\(elements.count))")
                DispatchQueue.main.sync {
                    self.elements = elements
                }
                (completion ?? self.complelionBlock)(result)
            }
        }
        
    }
    
    // MARK: POST
    // реализация без complition handler, а если он все же используется, то без "_ in"
    public func post(_ completion: (() -> Void)? = nil) {
        postBody() { _ in
            (completion ?? self.complelionBlock)()
        }
    }
    // реализация cо значением c complition handler
    public func post(_ completion: @escaping (GetRequest<GetType>) -> Void) {
        postBody() { result in
            completion(result)
        }
    }
    
    public func postBody(_ completion: ((GetRequest<GetType>) -> Void)? = nil) {
        usersRequest = Request<GetType>(resourcePath: "\(baseURL + self.path)")
        usersRequest!.save(value, method: "POST") { result in

            switch result {
            case .failure:
                print("post() - There was an error getting the tasks")
                (completion ?? self.complelionBlock)(result)
            case .successOne(let value):
                DispatchQueue.main.sync {
                    self.value = value
                    (completion ?? self.complelionBlock)(result)
                }
            case .successArray(let elements):
                print("Пришел массив: path - \(self.path), elements.count(\(elements.count))")
                DispatchQueue.main.sync {
                    self.elements = elements
                }
                (completion ?? self.complelionBlock)(result)
            }
        }
        
    }
    
    // MARK: PUT
    public func put(_ completion: ((GetRequest<GetType>) -> Void)? = nil) {
        
        
        usersRequest = Request<GetType>(resourcePath: "\(baseURL + self.path)")
        //print(data.username)
        usersRequest!.save(value!, method: "PUT") { result in
            
            switch result {
            case .failure:
                print("put() - There was an error getting the tasks")
                (completion ?? self.complelionBlock)(result)
            case .successOne(let value):
                print("data: \(String(describing: value))")
                DispatchQueue.main.sync {
                    self.value = value
                }
                (completion ?? self.complelionBlock)(result)
            case .successArray(let elements):
                print("Пришел массив: path - \(self.path), elements.count(\(elements.count))")
                DispatchQueue.main.sync {
                    self.elements = elements
                }
                (completion ?? self.complelionBlock)(result)
            }
        }
    }
    
    public func delete(_ completion: ((GetRequest<GetType>) -> Void)? = nil) {
        usersRequest = Request<GetType>(resourcePath: "\(baseURL + self.path)")
        //print(data.username)
        usersRequest!.save(value, method: "DELETE") { result in

            switch result {
            case .failure:
                print("delete() - There was an error getting the tasks")
                (completion ?? self.complelionBlock)(result)
            case .successOne(let data):
                print("delete() - Success! StatusCode: data: \(String(describing: data))")
                DispatchQueue.main.sync {
                    self.value = nil
                }
                (completion ?? self.complelionBlock)(result)
            case .successArray(let elements):
                print("Пришел массив: path - \(self.path), elements.count(\(elements.count))")
                DispatchQueue.main.sync {
                    self.elements = elements
                }
                (completion ?? self.complelionBlock)(result)
            }
        }
    }
    
    public func patch(_ completion: ((GetRequest<GetType>) -> Void)? = nil) {
        usersRequest = Request<GetType>(resourcePath: "\(baseURL + self.path)")
        //print(data.username)
        usersRequest!.save(value, method: "PATCH") { result in

            switch result {
            case .failure:
                print("delete() - There was an error getting the tasks")
                (completion ?? self.complelionBlock)(result)
            case .successOne(let data):
                print("delete() - Success! StatusCode: data: \(String(describing: data))")
                DispatchQueue.main.sync {
                    self.value = nil
                }
                (completion ?? self.complelionBlock)(result)
            case .successArray(let elements):
                print("Пришел массив: path - \(self.path), elements.count(\(elements.count))")
                DispatchQueue.main.sync {
                    self.elements = elements
                }
                (completion ?? self.complelionBlock)(result)
            }
        }
    }
    
    
    public func complelionBlock(result: GetRequest<GetType>) -> Void {
        print("defaul complelionBlock  with SaveResult: \(GetType.self)")
    }
    
    public func complelionBlock() -> Void {
        print("defaul complelionBlock")
    }
    

    
    // Сейчас не использоуется - но может пригодиться
    // Функция достает картинку только по одному URL без Authorization и Content-Type
//    func getAmazonImage() {
//
//        guard var urlStringImage = self.imagePath else {
//            print("imageURL для закачки изображения отсутствует")
//            return
//        }
//
//        urlStringImage = "https://dualism.s3-eu-west-3.amazonaws.com/" + urlStringImage + ".jpg"
//
//        let url = URL(string: urlStringImage.encodeUrl)
//
//        print("getImage() url: \(urlStringImage)")
//
//        DispatchQueue.main.async {
//
//            do {
//                let data = try Data(contentsOf: url!)
//                self.value = (data as! GetType)
//
//            } catch let error {
//
//                print("Could not save because of \(error).")
//                self.value = (UIImage(named: "notAvatar")?.pngData() as! GetType)// Вдруг вылет
//            }
//
//        }
//    }
    
}
