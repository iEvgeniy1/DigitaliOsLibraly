//
//  ProductImages.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 17.04.2022.
//

import SwiftUI

struct ProductImages: View {
    
    var optionalImages: [String]?
    var shownPhoto: String
    @State var mainImage: AnyView
    @State var loading: Bool = false
    
    init(optionalImages: [String]?, shownPhoto: String) {
        self.shownPhoto = shownPhoto
        self.optionalImages = optionalImages
        mainImage = AnyView(
            ImageLoad(nameImage: shownPhoto,
                      width: UIScreen.main.bounds.width / 1.1,
                      height: 350)
            )
    }
    
    var body: some View {
        VStack {
            VStack {
                if loading {
                    mainImage
                        .padding(.horizontal, 25.0)
                        .cornerRadius(10)
                } else {
                    mainImage
                        .padding(.horizontal, 25.0)
                        .cornerRadius(10)
                }
            }
            .frame(height: 350)
            
            ScrollView(.horizontal) {
                HStack {
                    if let images = optionalImages, images.count > 0 {
                        Button(action: {
                            loading.toggle()
                            mainImage = AnyView(
                                ImageLoad(nameImage: shownPhoto,
                                          width: UIScreen.main.bounds.width / 1.1,
                                          height: 350)
                                )
                            
                        }) {
                            ImageLoad(nameImage: shownPhoto,
                                      width: 75,
                                      height: 100)
                                .cornerRadius(10)
                                .frame(height: 75)
                        }
                        
                        ForEach((0..<images.count).reversed(), id: \.self) { index in
                            Button(action: {
                                loading.toggle()
                                mainImage = AnyView(
                                    ImageLoad(nameImage: images[index],
                                              width: UIScreen.main.bounds.width / 1.1,
                                              height: 350)
                                    )
                                
                            }) {
                                ImageLoad(nameImage: images[index],
                                          width: 75,
                                          height: 100)
                                    .cornerRadius(10)
                                    .frame(height: 75)
                            }
                        }
                    }
                }
            }
        }
    }
    
}

struct ProductImages_Previews: PreviewProvider {
    static var previews: some View {
        ProductImages(optionalImages: Product().array["optionalImages"], shownPhoto: "/images/mat/olivia.png")
    }
}
