//
//  PrivacyPolicy.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 10.01.2022.
//  Copyright © 2022 EVGENIY DAN. All rights reserved.
//

import SwiftUI

struct PrivacyPolicy: View {
    
    struct Mail: Codable {
        var email: String?
    }
    
    @Binding var showPrivacyPolicy: Bool
    @State var emailAddress: String = ""
    
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertDescription: String = ""
    
    var body: some View {
        
        ScrollView {
            
            HTMLFormattedText(lang["policy1"] ?? "Privacy policy")
                
            HTMLFormattedText(lang["policy2"] ?? "Privacy policy")
            
            HTMLFormattedText(lang["policy3"] ?? "Privacy policy")
            
            HTMLFormattedText(lang["policy4"] ?? "Privacy policy")
            
            Button(action: {
                showPrivacyPolicy = false
            }) {
                Text(lang["ok"] ?? "Ok")
            }
            
        }
        .preferredColorScheme(.light)
        .navigationBarTitle(lang["privacyPolicy"] ?? "Privacy policy", displayMode: .inline)
    }
}



struct PrivacyPolicy_Previews: PreviewProvider {
    @State var showPrivacyPolicy: Bool = false
    static var previews: some View {
        PrivacyPolicy(showPrivacyPolicy: Self().$showPrivacyPolicy)
            .preferredColorScheme(.dark)
    }
}

