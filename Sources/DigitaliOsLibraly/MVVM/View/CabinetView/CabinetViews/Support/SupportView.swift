//
//  SupportView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 25.03.2022.
//

import SwiftUI

struct SupportView: View {
    @StateObject var message: Load<Message> = .init("/api/cabinet/getTickets")
    @StateObject var user = Load<User>("/api/login/getUserBySession")
    @State var text = ""
    @State var height: CGFloat = 35
    @State var width = UIScreen.main.bounds.width - 100
    var testVeiw: Bool = false
    var body: some View {
        VStack {
            let messageTitle = lang["user_technicalSupport"] ??  "Communication with technical support"
            Text(messageTitle)
            
            ScrollView {
                
                ForEach(0..<self.message.elements.count, id: \.self) { i in
                    let message = self.message.elements[i]
                    let authId = message.auth?.id
                    let userId = user.value?.id
                    
                    if authId == userId {
                        HStack {
                            HStack {
                                ImageLoad(nameImage: message.picture ?? User.defaultImagies,
                                          width: 50,
                                          height: 50)
                                    .clipShape(Circle())
                                    .padding(.leading, 8.0)
                                    .shadow(radius: 10)
                                    .frame(width: 30.0, height: 30.0)
                                Spacer()
                                Text(message.message)
                                    .padding(.leading, 8.0)
                            }
                            .padding(.all)
                            .frame(width: UIScreen.main.bounds.width - 70)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 3)
                                    .padding(.horizontal, 2.0)
                            )
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                    } else {
                        HStack {
                            Spacer()
                            
                            HStack {
                                ImageLoad(nameImage: message.picture ?? User.defaultImagies,
                                          width: 50,
                                          height: 50)
                                    .clipShape(Circle())
                                    .padding(.leading, 8.0)
                                    .shadow(radius: 10)
                                    .frame(width: 30.0, height: 30.0)
                                Spacer()
                                Text(message.message)
                                    .padding(.leading, 8.0)
                                Spacer()
                            }
                            .padding(.all)
                            .frame(width: UIScreen.main.bounds.width - 70)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 3)
                                    .padding(.horizontal, 2.0)
                            )
                        }
                        .padding(.top)
                        
                    }
                    
                }
                .padding([.leading, .bottom, .trailing])
            }
            
            HStack {
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 4)
                        .frame(width: UIScreen.main.bounds.width - 100, height: self.height)
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(#colorLiteral(red: 0.9700000286, green: 0.9700000286, blue: 0.9700000286, alpha: 0.7953895246)))
                        .frame(width: UIScreen.main.bounds.width - 100, height: self.height)
                    
                    TextView(text: self.$text, height: $height, width: $width)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    
                }
                .padding(.leading)
                .fixedSize()
                
                Spacer()
                
                Button(action: {
                    
                    print("message text \(self.text)")
                    message.path = "/api/cabinet/postTickets/"
                    message.value = .init(message: self.text) // text from text field
                    
                    message.post()
                    
                    UIApplication.shared.endEditing() // send notification for closing keybord
                    
                    self.text = ""
                    height = 35
                }) {
                    RoundedRectangle(cornerRadius: 9)
                        .foregroundColor(.yellowSet)
                        .frame(width: 50, height: 35.0)
                        .overlay(
                            Image(systemName: "bubble.left.fill").font(.system(size: 20, weight: .medium)).foregroundColor(.white)
                        )
                        .padding(.trailing)
                }
            }
            .padding(.vertical)
        }
        .onTapGesture {
            print("All EditUserView taped")
            UIApplication.shared.endEditing()
        }
        .keyboardResponsive()
        .onAppear {
            if testVeiw {
                testInit()
            } else {
                user.get() {
                    message.get()
                }
            }
        }
    }
    
    func testInit() {
        message.elements = [
            Message(authIsMe: true),
            Message(authIsMe: false),
            Message(authIsMe: true)
        ]
        user.value = User(userExist: true)
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView(testVeiw: true)
    }
}
