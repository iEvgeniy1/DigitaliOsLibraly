//
//  Extentions.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 09.06.2020.
//  Copyright © 2020 EVGENIY DAN. All rights reserved.
//  Hello

import SwiftUI


extension UIColor {
    func convertToImage(for size:CGSize) -> UIImage {
        var img:UIImage?
        let rect = CGRect(x:0.0, y:0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.cgColor)
        context.fill(rect)
        img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension UIColor {
    convenience init(hex string: String, alpha: CGFloat = 1.0) {
        var hex = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        if hex.count < 3 {
            hex = "\(hex)\(hex)\(hex)"
        }
        
        if hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil {
            if hex.count == 3 {
                
                let startIndex = hex.index(hex.startIndex, offsetBy: 1)
                let endIndex = hex.index(hex.startIndex, offsetBy: 2)
                
                let redHex = String(hex[..<startIndex])
                let greenHex = String(hex[startIndex..<endIndex])
                let blueHex = String(hex[endIndex...])
                
                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }
            
            let startIndex = hex.index(hex.startIndex, offsetBy: 2)
            let endIndex = hex.index(hex.startIndex, offsetBy: 4)
            let redHex = String(hex[..<startIndex])
            let greenHex = String(hex[startIndex..<endIndex])
            let blueHex = String(hex[endIndex...])
            
            var redInt: UInt64 = 0
            var greenInt: UInt64 = 0
            var blueInt: UInt64 = 0
            
            Scanner(string: redHex).scanHexInt64(&redInt)//scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt64(&greenInt)
            Scanner(string: blueHex).scanHexInt64(&blueInt)
            
            self.init(red: CGFloat(redInt) / 255.0,
                      green: CGFloat(greenInt) / 255.0,
                      blue: CGFloat(blueInt) / 255.0,
                      alpha: CGFloat(alpha))
        }
        else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
}


// скруглить определенный угол прямоугольника
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension UIApplication {
    /// Checks if view hierarchy of application contains `UIRemoteKeyboardWindow` if it does, keyboard is presented
    var isKeyboardPresented: Bool {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let windows = windowScene?.windows
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"),
           ((windows?.contains(where: { $0.isKind(of: keyboardWindowClass) })) != nil) {
            return true
        } else {
            return false
        }
    }
    
// Use it
//    if UIApplication.shared.isKeyboardPresented {
//        showHeader = true
//    } else {
//        showHeader = false
//    }
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
    hidesBarsOnSwipe = true
    // other customizations
//    navigationBar.tintColor = .white
 }
}


// расширение чтобы можно было $value.ooo.onNone("") - тогда становится возможным использовать опциональные значения в связанных данных
extension Binding where Value == String? {
    func onNone(_ fallback: String) -> Binding<String> {
        return Binding<String>(get: {
            return self.wrappedValue ?? fallback
        }) { value in
            self.wrappedValue = value
        }
    }
}


extension Binding where Value == Bool? {
    func onNoneBool(_ fallback: Bool) -> Binding<Bool> {
        return Binding<Bool>(get: {
            return self.wrappedValue ?? fallback
        }) { value in
            self.wrappedValue = value
        }
    }
}


//MARK: String
extension String {
    
    public mutating func searchAndReplace(pattern: String, replacing: String) {
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let string = self as NSString
            
            let nsTextCheckingResult = regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length))

            for result in nsTextCheckingResult {
                
                let object = string.substring(with: result.range)
                let replacingString = self.replacingOccurrences(of: object, with: replacing)
                //  print(replacingString)
                self = replacingString
            }
        }
    }
    
    func searchReferer(pattern: String) -> Bool
    // pattern: "Referer:[a-z0-9/:.]+" - в квадратных ковычках нужны тот симовол или символы который ожидаются после Referer:
    {
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        {
            let string = self as NSString
            
            let stringArray = regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                // replacing: "Referer: "
                string.substring(with: $0.range)//.replacingOccurrences(of: replacing, with: "")//.lowercased()
            }
            
            if stringArray.isEmpty {
                return false
            }
        }
        
        return true
    }
    
    // находит если совпадений патерна много, изменяет self и возвращает в одной строке
    mutating func searchObjects(pattern: String, replacing: String) -> String {
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        {
            let string = self as NSString
            
            let nsTextCheckingResult = regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length))

            for result in nsTextCheckingResult {
                
                let object = string.substring(with: result.range)
                let replacingString = self.replacingOccurrences(of: object, with: replacing)
                //  print(replacingString)
                self = replacingString
                
            }
            
            return self
        } else {
            return ""
        }
        
    }
    
    
    public func trimHTMLTags() -> String {
        
        guard let htmlStringData = self.data(using: String.Encoding.utf8) else {
            return ""
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let attributedString = try? NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
        return attributedString?.string ?? ""
    }
}

extension String {
    func countToWidth() -> CGFloat {
        return CGFloat(self.count * 10 + 40)
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont, _ horisontalPadding: CGFloat) -> CGFloat {
        let width = self.widthOfString(usingFont: UIFont.systemFont(ofSize: font.lineHeight, weight: .regular))
        let lineOfText = width / (UIScreen.main.bounds.width-horisontalPadding)
        let height = lineOfText * (font.lineHeight*2) + font.lineHeight
        return height
    }
}


extension String {
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}




/*
 нужно для того чтобы  словарь имел возможность отдавать значение по умолчанию и его можно было принудительно извлечь
 var dict = [1:10, 2:8, 3:6]
 dict[4, or: 1000]
 вернет 1000 и установит значение
 */
extension Dictionary {
    subscript(key : Key, or r: Value) -> Value {
        mutating get {
            if self[key] == nil {
                self[key] = r
            }
            return self[key]!
        }
//        set {
//            self[key] = r
//        }
    }
}


extension UIImage {
    
    /*
     1)
     myImage = myImage.resizeWithWidth(700)!
     2)
     let compressData = UIImageJPEGRepresentation(myImage, 0.5) //max value is 1.0 and minimum is 0.0
     let compressedImage = UIImage(data: compressData!)
     */
    
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}


