//
//  TextView.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 02.07.2020.
//  Copyright © 2020 EVGENIY DAN. All rights reserved.
//

import SwiftUI

// так как в iOs 13 не работал TextField с авто переносом, то пришлось использовать UIKit
struct TextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    @Binding var width: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {

        let myTextView = UITextView()
        myTextView.delegate = context.coordinator

        myTextView.font = UIFont(name: "HelveticaNeue", size: 15)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor(white: 0.0, alpha: 0.05)

        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            print("text now: \(String(describing: textView.text!))")
            self.parent.text = textView.text
            
            let size = CGSize(width: 300.0, // так как используется только факт бесконечности в высоту, то можно обойтись без передачи реальной ширины - это значение, вроде как, все равно игнориется!
                               height: .infinity)
            let estiatedSize = textView.sizeThatFits(size)
            self.parent.height = estiatedSize.height < self.parent.width/2 ? estiatedSize.height : self.parent.width/2
        }
    }
}
