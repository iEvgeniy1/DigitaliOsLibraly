//
//  LoadProfileView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 26.04.2022.
//

import SwiftUI

struct LoadProfileView: View {
    @StateObject var user = Load<User>("/api/login/getUserBySession")
    @State var loading: Bool = true
    @State var listEmpty: Bool = false
    
    var body: some View {
        ZStack {
            
            ProfileView(user: user)
            
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

struct LoadProfileView_Previews: PreviewProvider {
    static var previews: some View {
        LoadProfileView()
    }
}
