//
//  PointsView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 25.03.2022.
//

import SwiftUI

struct PointsView: View {
    @StateObject var order: Load<Order> = .init("/api/cabinet/getOrders")
    var testVeiw: Bool = false
    var body: some View {
        
        VStack {
            
            let cumulativePoints = lang["accumulatedPoints"] ??  "Accumulated points"
            Text(cumulativePoints)
            
            ScrollView {
                ForEach(0..<self.order.elements.count, id: \.self) { i in
                    let order = self.order.elements[i]
                    
                    HStack {
                        VStack(alignment: .leading) {
                            let status = lang["status"] ??  "Status: "
                            let paymentStatus = order.paymentStatus.translate()
                            Text(status + paymentStatus)
                            let orderNumberText = lang["user_orderNumber"] ??  "Order number: "
                            let orderNumber = String(order.numberOrder)
                            Text(orderNumberText + orderNumber)
                            let from = lang["from"] ??  "From: "
                            let date = order.date.components(separatedBy: "T").first ?? "error_date"
                            Text(from + date)
                            let orderSum = lang["admin_sumOfOrder"] ??  "Order amount: "
                            let sumTotal = String(order.sumTotal)
                            Text(orderSum + sumTotal)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            let points = String(order.points)
                            
                            if order.paymentStatus != .paid {
                                Text(points)
                                    .font(.title2)
                                    .foregroundColor(.yellowSet)
                                    .padding(.trailing, 10.0)
                                let accessToPoints = lang["pointsWillBeAvailable"] ??  "Points will be available after full payment of the order"
                                Text(accessToPoints)
                                    .font(.caption2)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 110.0)
                            } else {
                                Text(points)
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                                    .padding(.trailing, 10.0)
                            }
                        }
                        
                    }
                    .padding(.all)
                    .frame(width: UIScreen.main.bounds.width - 25, height: 125)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 3)
                            .padding(.horizontal, 2.0)
                    )
                }
                .padding(.top)
            }
            
        }
        .onAppear {
            if testVeiw {
                testInit()
            } else {
                order.get()
            }
        }
    }
    
    func testInit() {
        order.elements = [
            Order(test: true),
            Order(test: true),
            Order(test: true),
            Order(test: true)
        ]
    }
}

struct PointsView_Previews: PreviewProvider {
    static var previews: some View {
        PointsView(testVeiw: true)
    }
}
