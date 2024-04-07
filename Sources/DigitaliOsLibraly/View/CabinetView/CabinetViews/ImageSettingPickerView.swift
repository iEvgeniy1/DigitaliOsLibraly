//
//  ImageSettingPickerView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 27.04.2022.
//

import SwiftUI
import Foundation

struct ImageSettingPickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @ObservedObject var user: Load<User>
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageSettingPickerView>) -> some UIViewController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> ImageSettingPickerView.Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImageSettingPickerView
        init(parent: ImageSettingPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                print(selectedImage)
                let image = selectedImage.resizeWithWidth(width: 500)!
                let imageData: Data = image.pngData()!
                self.parent.user.value?.pictureData = imageData
                self.parent.user.value?.password = ""
                print("after new data")
                self.parent.user.path = "/api/cabinet/profilePut/"
                cacheData[self.parent.user.value?.picture ?? ""] = nil
                self.parent.user.post()
                self.parent.user.value = nil
            }
            self.parent.isPresented = false
        }
    }
    
    func updateUIViewController(_ uiViewController: ImageSettingPickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImageSettingPickerView>) {
        
    }
    
}

