//
//  OrdersView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 24.03.2022.
//

import SwiftUI

struct OrdersView: View {
    @StateObject var order: Load<Order> = .init("/api/cabinet/getOrders")
    @State var showOrderDetail: Bool = false
    var testVeiw: Bool = false
    var body: some View {
        VStack {
            let title = lang["orders"] ?? "Orders"
            Text(title)
            
            ScrollView {
                
                ForEach(0..<self.order.elements.count, id: \.self) { i in
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.textDarkWhiteSet, lineWidth: 2)
                            .padding(.horizontal)
                        
                        VStack {
                            let order = self.order.elements[i]
                            let sumTotal = String(order.sumTotal)
                            let numberOrder = String(order.numberOrder)
                            let date = order.date.components(separatedBy: "T").first ?? "error_date"
                            
                            HStack {
                                Text("№ \(numberOrder)")
                                    .frame(width: 80.0)
                                Divider()
                                Spacer()
                                Text(date)
                                Spacer()
                                Divider()
                                Text("\(sumTotal) р.")
                                    .frame(width: 100.0)
                            }
                            .padding([.top, .leading, .trailing])
                            .frame(height: 30.0)
                            
                            
                            let orderDetail = lang["order_details"] ??  "Order Details:"
                            let paymentStatus = order.paymentStatus.translate()
                            let orderStatus = order.orderStatus.translate()
                            let textOrder = orderDetail + " " + paymentStatus + ". " + orderStatus
                            Button(action: {
                                showOrderDetail = true
                            }) {
                                Text(textOrder)
                                Spacer()
                                Image(systemName: "eye")
                                    .resizable()
                                    .frame(width: 25, height: 18)
                            }
                            .padding(.horizontal, 25)
                            .foregroundColor(Color.blue)
                            .padding(.vertical, 10.0)
                            .sheet(isPresented: $showOrderDetail, content: {
                                NavigationView {
                                    let orderDetail = lang["order_details"] ?? "Order Details"
                                    let close = lang["close"] ?? "Close"
                                    OrderDetailView(shoppingCart: Load<ShoppingCart>("/api/cabinet/shoppingCart/\(numberOrder)"))
                                        .navigationBarTitle(Text(orderDetail), displayMode: .inline)
                                        .navigationBarItems(trailing: Button(close) { showOrderDetail.toggle() })
                                }
                            })
                        }
                        
                    }
                    
                    
                }
                .padding(.top)
                
            }
        }
        .onAppear {
            if testVeiw {
                order.elements = [
                    Order(test: true),
                    Order(test: true),
                    Order(test: true)
                ]
            } else {
                order.get()
            }
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(testVeiw: true)
    }
}
