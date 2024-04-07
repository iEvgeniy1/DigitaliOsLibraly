//
//  LoadAddressView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 27.04.2022.
//

import SwiftUI

struct LoadAddressView: View {
    @StateObject var user = Load<User>("/api/login/getUserBySession")
    @State var loading: Bool = true
    @State var listEmpty: Bool = false
    
    var body: some View {
        ZStack {
            
            AddressView(user: user)
            
            if loading == true {
                ProfileAnimationLoad()
                    .background()
                    .onAppear {
                        user.get() {
                            loading = false
                        }
                    }
                
            }
            
        }
        
    }
}

struct LoadAddressView_Previews: PreviewProvider {
    static var previews: some View {
        LoadAddressView()
    }
}
