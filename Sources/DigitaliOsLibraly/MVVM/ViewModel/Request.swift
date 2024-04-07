//
//  Request.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 27.06.2020.
//  Copyright © 2020 EVGENIY DAN. All rights reserved.
//

import SwiftUI

public enum GetRequest<ResourceType> {
    case successArray([ResourceType])
    case successOne(ResourceType)
    case failure(Int, Data?)
}


class Request<ResourceType> where ResourceType: Codable {
    
    let resourceURL: URL
    
    init(resourcePath: String) {
//        let path = Bundle.main.path(forResource: "notAvatar", ofType: "png")
        let encodedURL = resourcePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let finalUrl = encodedURL, let url = URL(string: finalUrl) {
            self.resourceURL = url
        } else {
            print("invalid url")
            self.resourceURL = URL(string: "https://")!
        }
    }
    
    
    
    // 4 Define a function to get all values of the resource type from the API. This takes a completion closure as a parameter.
    func get(completion: @escaping (GetRequest<ResourceType>) -> Void) {
        var urlRequest = URLRequest(url: resourceURL)
        print("urlRequest get: \(urlRequest)")
        if let session = Auth().session  {
            if ResourceType.self != Data.self {
                urlRequest.addValue("BearerSession \(session)", forHTTPHeaderField: "Authorization")
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } else {
//                print("Запрашиваем Data без авторизации чтобы Amazon не ругался!")
            }
        }
        let dataTask = getRequest(urlRequest: urlRequest, completion: completion)
        
        dataTask.resume()
    }
    
    // 1 Declare a method save(_:completion:) that takes the resource to save and a completion handler that takes the save result.
    func save(_ resourceToSave: ResourceType?, method: String, completion: @escaping (GetRequest<ResourceType>) -> Void) {
        
        // 2 Create a URLRequest for the save request.
        var urlRequest = URLRequest(url: resourceURL)
        print("urlRequest save: \(urlRequest)")
        // 3 Set the HTTP method for the request to POST.
        urlRequest.httpMethod = method
        if let session = Auth().session  {
            urlRequest.addValue("BearerSession \(session)", forHTTPHeaderField: "Authorization")
        }
        // 4 Set the Content-Type header for the request to application/json so the API knows there’s JSON data to decode.
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(resourceToSave)
        } catch let error{
            print("error httpBody: \(error)")
        }

//            print("befor URLSession.shared.dataTask")
        let dataTask = getRequest(urlRequest: urlRequest, completion: completion)
        
        
        dataTask.resume()
            
    }
    
    
    private func getRequest(urlRequest: URLRequest,
                            completion: @escaping (GetRequest<ResourceType>) -> Void) -> URLSessionDataTask {
        
        return URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(6661, data))
                return
            }
            guard let jsonData = data else {
                print("jsonData is wrong: \(String(describing: data))")
                completion(.failure(httpResponse.statusCode, data))
                return
            }
            
            
    // Сначала пробую перевести пришедшую Data в String, если это не получается, то это изображение. Потом по первой квадратной скобки определяю что это массив и тогда работаю как с массивом, в другом случае как с структурой!
            
            do {
                
                guard let json = String(data: jsonData, encoding: .utf8) else {
                    print("Пришел jsonData, который не трансформируется в String - тогда это только Data")
                    completion(.successOne(jsonData as! ResourceType))
                    return
                }
                if json.first == "<" {
                    print("It's SVG")
                    let resources = try JSONDecoder().decode(ResourceType.self, from: jsonData)
                    completion(.successOne(resources))
                    return
                }
                if json.first == "[" {
                    print("It's array: \([ResourceType].self)")
                    let resources = try JSONDecoder().decode([ResourceType].self, from: jsonData)
                    completion(.successArray(resources))
                    return
                }
                if ResourceType.self is String.Type {
                    print("It's String Type")
                    let resources = json as! ResourceType
                    completion(.successOne(resources))
                } else {
//                    print("json: \(json)")
                    let resources = try JSONDecoder().decode(ResourceType.self, from: jsonData)
                    completion(.successOne(resources))
                }

            } catch {
                
                
                print("Request error get: \([ResourceType].self) error:\(error)")
                completion(.failure(httpResponse.statusCode, jsonData))
                print(self.decode(data: jsonData))
            }
            
            
        }
    }
    
    public func decode(data: Data?) -> String {
        
        var json = String(data: data ?? Data(), encoding: .utf8)!
        json = json.replacingOccurrences(of: "\\/", with: "/")
        
        return json
    }
    
}
