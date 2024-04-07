//
//  Spiner.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 16.01.2021.
//  Copyright © 2021 EVGENIY DAN. All rights reserved.
//


import UIKit
import Foundation
import SwiftUI

//override func awakeFromNib() {
//    super.awakeFromNib()
//    print("First")
//    SpinnerViewController().createSpinnerView(view: &self.view)
//}

public struct Spinner: UIViewRepresentable {
    public init() { }
    
    public let isAnimating: Bool = true
    public let style: UIActivityIndicatorView.Style = .large

    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.hidesWhenStopped = true
        return spinner
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

//
//class SpinnerViewController: UIViewController {
//
//    var spinner = UIActivityIndicatorView(style: .large)
//
//    override func loadView() {
//        view = UIView()
//        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
//
//        //MARK: Spiner
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        spinner.startAnimating()
//        spinner.color = .red
//        if #available(iOS 13.0, *) {
//            print("It was large!")
//            spinner.style = .large
//        } else {
//            print("It was smal!")
//        }
//        view.addSubview(spinner)
//        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//
//
//        //MARK: Text
//        let text = UILabel(frame: CGRect(
//                            x: UIScreen.main.bounds.size.width/2+30,
//                            y: UIScreen.main.bounds.size.height/2-15,
//                            width: 100, height: 30))
//        text.text = "loading..."
//        text.textColor = .white
//        //text.tintColor = .white
//
//        view.addSubview(text)
//
//    }
//
//    func createSpinnerView(view: inout UIView) {
////        let child = SpinnerViewController()
//
//        // add the spinner view controller
//        self.view.frame = view.frame
//        self.didMove(toParent: self)
//
//        // wait two seconds to simulate some work happening
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            // then remove the spinner view controller
//            self.willMove(toParent: nil)
//            self.view.removeFromSuperview()
//            self.removeFromParent()
//        }
////        addChild(child)
//        view.addSubview(self.view)
//
//    }
//}
