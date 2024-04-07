//
//  LoadSupporView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 26.04.2022.
//

import SwiftUI

struct LoadDeleteView: View {
    @StateObject var message: Load<Message> = .init("/api/cabinet/getTickets")
    @State var loading: Bool = true
    @State var listEmpty: Bool = false
    
    var body: some View {
        ZStack {
            
            DeleteView(message: message)
            
            if loading == true {
                SupportAnimationLoad()
                    .background()
                    .onAppear {
                        message.get() {
                            loading = false
                        }
                    }
                
            }
            
        }
        
    }
   
}

struct LoadDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        LoadDeleteView()
    }
}
