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
import UIKit

enum AuthResult {
    case success(loginCondition: String)
    case failure
}

public class Auth {
    
    public init() { }

    static public let session = "DigitaliOs-API-Session"
    
    let defaults = UserDefaults.standard
    
    public var session: String? {
        get {
            return defaults.string(forKey: Auth.session)
        }
        set {
            defaults.set(newValue, forKey: Auth.session)
        }
    }
    
    func logout(completion: @escaping () -> Void ) {
        print("Пользователь не авторизован!")
//        self.session = nil
        let path = mainHost + "/api/login/logout/"
        guard let url = URL(string: path) else { fatalError() }
        var loginRequest = URLRequest(url: url)
        loginRequest.httpMethod = "GET"
        loginRequest.addValue("BearerSession \(session!)", forHTTPHeaderField: "Authorization")
        loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataTask = URLSession.shared
            .dataTask(with: loginRequest) { data, response, _ in
                completion()
        }
        dataTask.resume()
    }
    
    // 1 «Declare a method to log a user in. This takes the user’s username, password and a completion handler as parameters.»
    func login(username: String, password: String, completion: @escaping (AuthResult) -> Void ) {
        
        // 2 «Construct the URL for the login request.»
        let path = mainHost + "/api/login/"
        print("Auth - login - path: \(path)")
        //let path = "https://rasti.herokuapp.com/api/users/login"
        
        
        guard let url = URL(string: path) else { fatalError() }
        // 3 «Create the base64-encoded representation of the user’s credentials for the header.»
        
        // 4 «Create a URLRequest for the request to log a user in.»
        var loginRequest = URLRequest(url: url)
        loginRequest.httpMethod = "POST"
        
        
        // 1) Отправляю логин и пароль в Basic
//        guard
//            let loginString = "\(username):\(password)"
//                .data(using: .utf8)?
//                .base64EncodedString()
//            else {
//                fatalError()
//        }
//        loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        if let session = Auth().session  {
            loginRequest.addValue("BearerSession \(session)", forHTTPHeaderField: "Authorization")
        }
        
        // 2) Отправляю логин и пароль в Content-Type
        loginRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        struct Input: Codable {
            let mail: String
            let password: String
        }
        let resourceToSave = Input(mail: username, password: password)
        
        
        
        do {
            loginRequest.httpBody = try JSONEncoder().encode(resourceToSave)
            //print(resourceToSave)
            
            // 6 «Create a new URLSessionDataTask to send the request.»
            let dataTask = URLSession.shared
                .dataTask(with: loginRequest) { data, response, _ in
//                    print(data?.base64EncodedString())
//                    print(response)
                    // 7 «Ensure the response is valid, has a status code of 200 and contains a body.»
                    guard
                        let httpResponse = response as? HTTPURLResponse,
                        httpResponse.statusCode == 200,
                        let jsonData = data
                        else {
                        print("completion failure")
                            completion(.failure)
                            return
                    }
                    
                    do {
                        print("Befor decode")
                        // 8 «Decode the response body into a Token.»
                        let session = try JSONDecoder()
                            .decode(LoginContext.self, from: jsonData)
                        // 9 «Save the received token as the Auth token.»
                        self.session = session.session
                        completion(.success(loginCondition: session.loginCondition ?? "loginCondition isn't exist"))
                    } catch {
                        print("token failure: \(error)")
                        completion(.failure)
                    }
            }
            // 11 «Start the data task to send the request.»
            dataTask.resume()
            
        } catch {
            print(error)
        }
        
        
        
    }
    
}
