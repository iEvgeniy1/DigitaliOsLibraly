//
//  ProductShowView.swift.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 26.03.2022.
//

import SwiftUI

enum ProductShowView: Equatable {
    
    case section(pathUrl: String, header: String?)
    case product(pathUrl: String, header: String?, productId: UUID?)
    case none
    
    func pathUrl() -> String {
        switch self {
        case .section(let pathUrl, _), .product(let pathUrl, _, _):
            return pathUrl
        case .none:
            return ""
        }
    }
    
    func header() -> String {
        switch self {
        case .section(_, let header), .product(_, let header, _):
            return header == nil ? "no header" : header!
        case .none:
            return ""
        }
    }

    func productId() -> String {
        switch self {
        case .section(_, _), .none:
            return ""
        case .product(_, _, let productId):
            return productId?.uuidString ?? "errorProductId"
        }
    }
}


struct ProductShownView: View {
    
    @State var productShowView: ProductShowView = .none
    
    @State var show: Bool = false {
        didSet {
            if show == false {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    productShowView = .none
                }
            }
        }
    }
    @State var offsetX: CGFloat = 0
    
    /// for multi-view
    @State var productUrl: String = "/api/"
    @State var productHeader: String = lang["catalog"] ?? "Catalog"
    @State var section: Bool = true
    @State var productId: String = ""
    
    @State var heartIcon: String = "heart"
    
    var body: some View {
        
        ZStack {
            
            VStack {
                HStack {
                    if productHeader != lang["catalog"] ?? "Catalog" {
                        Button(action: {
                            print("button pressed: \(productUrl)")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Close:" + productUrl), object: nil)
                        }) {
                            Image(systemName: "arrow.backward.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.trailing, 25.0)
                        }
                        .padding(.leading)
                        .foregroundColor(.textDarkWhiteSet)
                    }
                    Spacer()
                    Text(productHeader)
                        .lineLimit(1)
                    Spacer()
                    if section {
                        Text("")
                            .padding(.trailing, 25)
                    } else {
                        Button(action: {
                            let addOrDelete = heartIcon == "heart" ? "addToWishlist/\(productId)/1/" : "deleteFromWishlist/\(productId)/"
                            let shoppingCart = Load<Product>("/api/" + addOrDelete)
                            shoppingCart.get() {
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "needRenewWishlist"), object: nil)
                                }
                            }
                            heartIcon = heartIcon == "heart" ? "heart.fill" : "heart"
                        }) {
                            Image(systemName: heartIcon)
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 25.0)
                        }
                        .onAppear(perform: checkWishlistProductExist)
                        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("needRenewWishlist"))) { notification in
                            print("get notification: needRenewWishlist")
                            checkWishlistProductExist()
                        }
                    }
                    
                }
                if section {
                    if productHeader == lang["catalog"] ?? "Catalog" {
                        SearchProducts(productShowView: $productShowView)
                    }
                    LoadSection(products: Load<Product>(productUrl),
                                productShowView: $productShowView)
                        .onTapGesture {
                            print("Tap on empty place for closing keyboard")
                            UIApplication.shared.endEditing()
                        }
                } else {
                    LoadProduct(product: Load<Product>(productUrl))
                }
            }
            
            VStack {
                
                switch productShowView {
                case .section:
                    
                    let url: String = productShowView.pathUrl()
                    ProductShownView(productUrl: url,
                                     productHeader: productShowView.header(),
                                     section: true)
                        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("Close:" + url))) { _ in
                            withAnimation(.default) {
                                self.show = false
                            }
                        }
                    
                case .product:
                    
                    let url: String = productShowView.pathUrl()
                    ProductShownView(productUrl: url,
                                     productHeader: productShowView.header(),
                                     section: false,
                                     productId: productShowView.productId())
                        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("Close:" + url))) { _ in
                            withAnimation(.default) {
                                self.show = false
                            }
                        }
                    
                default:
                    EmptyView()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("showProductView"))) { _ in
                withAnimation(.default) {
                    if self.show == false {
                        self.show = true
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.textWhiteDarkSet)
            .offset(x: show ? offsetX : UIScreen.main.bounds.width)
            .gesture(
                DragGesture()
                    .onChanged {
                        /// swipe to left
                        if $0.startLocation.x < $0.location.x {
                            let changeX = -($0.startLocation.x - $0.location.x)
                            if changeX > 50 { // block missclick
                                withAnimation(.default) {
                                    offsetX = changeX
                                }
                            }
                        }
                    }
                    .onEnded{
                        if (UIScreen.main.bounds.width / 2) > -($0.startLocation.x - $0.location.x) {
                            withAnimation(.default) {
                                offsetX = 0
                            }
                        } else {
                            withAnimation(.default) {
                                offsetX = UIScreen.main.bounds.width
                                show = false
                                offsetX = 0
                            }
                        }
                    }
                )
            
        }

    }
    
    
    func checkWishlistProductExist() {
        let wishlist = Load<ShoppingCart>("/api/renewWishlist/")
        wishlist.get() {
            if wishlist.elements.map({ $0.productId == productId }).contains(true) {
                heartIcon = "heart.fill"
            } else {
                heartIcon = "heart"
            }
        }
    }
    
}

struct ProductShownView_Previews: PreviewProvider {
    @State var productShowView: ProductShowView = .product(pathUrl: "", header: "hello", productId: nil)
    
    static var previews: some View {
        ProductShownView(productShowView: Self().productShowView, show: true)
    }
}


