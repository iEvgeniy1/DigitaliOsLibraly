//
//  ImageLoad.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 23.01.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//

import SwiftUI



struct ImageLoad: View {
    
//    @Binding var images: [UUID : Image] // получаем хранилище для изображений
    
    @StateObject var imageLoad = Load<Data>()
    
    @State var nameImage: String // имя изображения в хранилище изображений
//    @State var id: UUID // получаем id элемента которому принадлежит изображение в хранилище изображений
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        
        HStack {
            if nameImage != "" {
                if imageLoad.value == nil {
                    
                    Spinner()
                        
                } else {
                        
                    let uiImage = UIImage(data: imageLoad.value!)!.withTintColor(.red)
                        
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height, alignment: .top)
                        .clipped()
                    
                }
            } else {
                
                Image(systemName: "photo.on.rectangle")
                    .resizable()
                    .font(.system(size: 100, weight: .regular))
                    .frame(width: width, height: height-50)
                    .foregroundColor(.gray)

            }
        }
        .onAppear {
            if nameImage != "" {
                print("nameImage: \(nameImage)")
                imageLoad.path = nameImage
//                imageLoad.idImage = id
                imageLoad.getDataWithCache()
            } else {
                print("nameImage == ''")
            }
        }
    }
    
}

struct ImageView_Previews: PreviewProvider {
    
    @State var nameImage = ""
    @State var id = UUID()
    
    static var previews: some View {
        ImageLoad(nameImage: Self().nameImage, width: 150, height: 215)
    }
}

