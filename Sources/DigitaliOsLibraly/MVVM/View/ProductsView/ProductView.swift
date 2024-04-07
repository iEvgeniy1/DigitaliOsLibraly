//
//  ProductDetail.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 26.03.2022.
//

import SwiftUI

struct ProductView: View {
    @StateObject var product: Load<Product>
    @StateObject var shoppingCart: Load<ShoppingCart> = .init()
    
    @State var description: String? = nil
    @State var descriptionLarge: String? = nil
    
    @State var buttonColor: Color = .yellowSet
    @State var shownPhoto: String = ""
    
    @State var sizesTag = 0
    @State var sizeSelected: String = "не выбран"
    
    @State var colorsTag = 0
    @State var colorSelected: String = "не выбран"
    
//    @State var colors: [Dictionaries] = []
    @State var colors: [String] = []
    @State var sizes: [String] = []
    
    var body: some View {
        ZStack {
            ScrollView {
                
                if shownPhoto == "" {
                    VStack  {
                        Spinner()
                            .frame(height: 350)
                    }
                } else {
                    ProductImages(optionalImages: product.value?.array["optionalImages"], shownPhoto: shownPhoto)
                }
                
                
                if !sizes.isEmpty {
                    let chooseSize = lang["chooseSize"] ?? "Choose a size:"
                    HStack {
                        Text(chooseSize)
                        Picker(selection: $sizesTag, label: EmptyView()) {
                            ForEach(0..<sizes.count, id: \.self) { i in
                                Text(sizes[i]).tag(i+1)
                            }
                        }.onChange(of: sizesTag) { tag in
                            sizeSelected = sizes[tag-1]
                            print("sizeSelected: \(sizeSelected)")
                        }.onAppear {
                            if !sizes.isEmpty {
                                sizeSelected = sizes[0]
                                print("size onAppear: \(sizeSelected)")
                            }
                        }
                    }
                    .padding(.top)
                }
                
                if !colors.isEmpty {
                    let chooseColor = lang["chooseColor"] ?? "Choose a color:"
                    HStack {
                        Text(chooseColor)
                        Picker(selection: $colorsTag, label: EmptyView()) {
                            ForEach(0..<colors.count, id: \.self) { i in
                                Text(colors[i]).tag(i+1)
//                                HStack {
//                                    Text("  \(colors[i].h1)  ")
//                                    let uiColor = UIColor(hex: colors[i].description)
//                                    Image(uiImage: uiColor.convertToImage(for: CGSize(width: 30, height: 30)))
//                                        .tag(i+1)
//                                }
                            }
                        }
                        .onChange(of: colorsTag) { tag in
//                            colorSelected = colors[tag].h1
                            colorSelected = colors[tag-1]
                            print("colorSelected h1: \(colorSelected)")
                            print("colorSelected description: \(colors[tag].description)")
                        }
                        .onAppear {
                            if !colors.isEmpty {
//                                colorSelected = colors[0].h1
                                colorSelected = colors[0]
                                print("color onAppear: \(colorSelected)")
                            }
                        }
                    }
                }
                
                
                VStack {
                    
                    HStack {
                        Spacer()
                        let artName = lang["vendorCode"] ?? "Vendor code"
                        Text(artName)
                            .font(.caption2)
                        let artValue = product.value?.value["artikul"] ?? ""
                        Text(artValue)
                            .font(.caption2)
                    }
                    .padding(.top, 10.0)
                    .padding(.bottom, 5.0)
                    .foregroundColor(Color.textCard)
                    
                    HStack {
                        let productName = product.value?.value["h1"] ?? ""
                        Text(productName)
                            .foregroundColor(Color.textCard)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                    }
                    
                    Divider()
                    
                    VStack(spacing: 5) {
                        HStack {
                            Spacer()
                            if (description != nil) {
                                Text(description!)
                                    .font(.headline)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        HStack {
                            Spacer()
                            if (descriptionLarge != nil) {
                                Text(descriptionLarge!)
                                    .font(.headline)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        
                        
                        HStack {
                            let priceName = lang["price"] ?? "Price:"
                            Text(priceName)
                            Spacer()
                            let price = product.value?.value["price"] ?? ""
                            let currency = lang["currency"] ?? " "
                            let priceWithCarancy = price + " " + currency
                            Text(priceWithCarancy)
                                .foregroundColor(Color.cyan)
                                .font(.title)
                        }
                        .padding(.bottom)
                    }
                    .padding(.bottom, 55.0)
                }
                .padding(.horizontal, 25.0)
            }
            
            
            
            VStack {
                Spacer()
                Button(lang["addToShoppingCart"] ??  "Add to Cart") {
                    let productId = product.value?.value["id"] ?? "errorProductId"
//                    let addOrDelete = buttonColor == .yellowSet ? "add/\(productId)/1/" : "delete/\(productId)/"
//                    shoppingCart.path = "/api/" + addOrDelete
                    colorSelected = colorSelected.searchObjects(pattern: "/", replacing: "-")
                    sizeSelected = sizeSelected.searchObjects(pattern: "/", replacing: "-")
                    let colorText = colors.isEmpty ? " " : " \(colorSelected)"
                    let sizeText = sizes.isEmpty ? " " : " \(sizeSelected)"
                    shoppingCart.path = "/api/add/\(productId)/1/\(colorText)/\(sizeText)"
                    shoppingCart.get() {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "needRenewShoppingCart"), object: nil)
                        }
                    }
                    withAnimation {
                        buttonColor = buttonColor == .yellowSet ? .textDarkWhiteSet : .yellowSet
                    }
                }
                .padding(.bottom, 20.0)
                .buttonStyle(ButtonStyleFullRelative(buttonColor))
            }
            
        }
        .onAppear {
            product.get() {
//                colors = self.product.value?.dic["colors"] ?? []
                colors = self.product.value?.array["colors"] ?? []
                sizes = self.product.value?.array["sizes"] ?? []
                
                shownPhoto = product.value?.value["photo"] ?? ""
                
                description = (product.value?.value["announcement"] ?? "").trimHTMLTags()
                descriptionLarge = (product.value?.value["description"] ?? "").trimHTMLTags()
                
                checkShoppingCartProductExist()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("needRenewShoppingCart"))) { notification in
            print("get notification: needRenewShoppingCart")
            checkShoppingCartProductExist()
        }
    }
    
    func checkShoppingCartProductExist() {
        let shoppingCart = Load<ShoppingCart>("/api/renewShoppingCart/")
        shoppingCart.get() {
            if shoppingCart.elements.map({ $0.productId == product.value?.value["id"] }).contains(true) {
                buttonColor = .textDarkWhiteSet
            } else {
                buttonColor = .yellowSet
            }
        }
    }
    
}

struct ProductDetail_Previews: PreviewProvider {
    var product = Load<Product>()
    init() {
        product.value = Product()
    }
    static var previews: some View {
        ProductView(product: Self().product)
    }
}

