//
//  LoadOrdersView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 26.04.2022.
//

import SwiftUI

struct LoadOrdersView: View {
    @StateObject var order: Load<Order> = .init("/api/cabinet/getOrders")
    @State var loading: Bool = true
    @State var listEmpty: Bool = false
    
    var body: some View {
        ZStack {
            
            OrdersView(order: order)
            
            if loading == true {
                OrdersAnimationLoad()
                    .background()
                    .onAppear {
                        loadOrders()
                    }
                
            }
            
            if listEmpty {
                let listEmpty = lang["yourListOrdersEmpty"] ?? "Your list of orders for now let"
                Text(listEmpty)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            }
            
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("showOrders"))) { notification in
            loadOrders()
        }
    }
    
    func loadOrders() {
        order.get() {
            if order.elements.count == 0 {
                listEmpty = true
            }
            loading = false
        }
    }
}

struct LoadOrdersView_Previews: PreviewProvider {
    static var previews: some View {
        LoadOrdersView()
    }
}
