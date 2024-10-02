//
//  ShowPayment.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 30.03.2022.
//
//
//import SwiftUI
//
//struct PaymentView: View {
//    @StateObject var user: Load<User> = .init("/api/login/getUserBySession/")
//    @StateObject var sumInShoppingCart: Load<Int> = .init("/api/checkout/countSumInShoppingCart")
//    @StateObject var settingPublic: Load<SettingPublic> = .init("/api/checkout/settingPublic/")
//    @Binding var showSelf: Bool
//    @State var showReviewOrder: Bool = false
//    @State var wantUsePoints: Bool = true
//    @State var canUsePoints: Int = 0
//    
//    @State var amassPointCount: Int = 0
//    var body: some View {
//        VStack {
//            let payment = lang["payment"] ?? "Payment"
//            Text(payment)
//            
//            Spacer()
//            
//            Toggle(isOn: $wantUsePoints) {
//                if wantUsePoints {
//                    Text("Использовать баллы: ")
//                    Text("\(canUsePoints)")
//                } else {
//                    Text("Копить баллы")
//                }
//            }
//            .onChange(of: wantUsePoints) { value in
//                Load<Int>("/api/checkout/usePoints/\(value)/").get() {
//                    user.value?.wantUsePoints = value
//                    sumInShoppingCart.get() {
//                        
//                    }
//                }
//            }
//            
//            if wantUsePoints {
//                let spendPoints = " На ваше счету \(canUsePoints) баллов. Сумма покупки уменьшится на \(canUsePoints) р. \r После использования баллов стоимость заказа составит \(sumInShoppingCart.value ?? 0)"
//                Text(spendPoints)
//                    .padding(.horizontal)
//                    .foregroundColor(Color.textCard)
//                    .frame(width: UIScreen.main.bounds.width - 45, height: 185)
//                    .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.yellowSet, lineWidth: 2)
//                        )
//                    .padding(.top, 20.0)
//            } else {
//                let amassPoints = " Cтоимость покупки составит \(sumInShoppingCart.value ?? 0). \r Вы накопите баллов - \(amassPointCount). \r Каждый балл равен одному рублю и может быть в дальнейшем использован для оплаты заказов."
//                Text(amassPoints)
//                    .padding(.horizontal)
//                    .foregroundColor(Color.textCard)
//                    .frame(width: UIScreen.main.bounds.width - 45, height: 185)
//                    .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.green, lineWidth: 2)
//                        )
//                    .padding(.top, 20.0)
//            }
//            
//            Spacer()
//            
//            Button(action: {
//                Load<String>("/api/checkout/review/").get()
//                showReviewOrder = true
//            }) {
//                let agree = lang["confirmation"] ?? "Confirmation"
//                ShoppingcartButton(text: agree)
//                    .navigationDestination(isPresented: $showReviewOrder) {
//                        ReviewOrderView(showSelf: $showReviewOrder)
//                    }
//            }
//            
//        }
//        .padding(.horizontal)
//        .onAppear {
//            sumInShoppingCart.get() {
//                settingPublic.get() {
//                    amassPointCount = (sumInShoppingCart.value ?? 0) / 100 * (settingPublic.value?.returnPoints ?? 0)
//                }
//            }
//            
//            user.get() {
//                wantUsePoints = user.value?.wantUsePoints == true ? true : false
//                canUsePoints = user.value?.canUsePoints ?? 0
//            }
//        }
//        
//    }
//}
//
//struct ShowPayment_Previews: PreviewProvider {
//    @State var showSelf: Bool = true
//    static var previews: some View {
//        PaymentView(showSelf: Self().$showSelf)
//    }
//}
