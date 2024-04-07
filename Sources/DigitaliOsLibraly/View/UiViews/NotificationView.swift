//
//  NotificationView.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 04.04.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import SwiftUI

struct NotificationView: View {
    
    @Binding var notification: String
    @State var width: CGFloat = 20
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(.red)
                .frame(width: CGFloat(notification.count) == 0 ? 0 : CGFloat(notification.count) * width/2 + width/2, height: 20)
            Text(notification)
                .foregroundColor(.white)
        }
        .padding(.leading, 28.0)
        .padding(.bottom, 5.0)
    }
}

struct NotificationView_Previews: PreviewProvider {
    
    @State var notification: String = "12"
    
    static var previews: some View {
        NotificationView(notification: Self().$notification)
    }
}
