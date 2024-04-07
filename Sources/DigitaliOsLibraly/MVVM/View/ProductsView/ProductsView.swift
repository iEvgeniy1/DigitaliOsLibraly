//
//  ProductsView.swift
//  DigitaliOs
//
//  Created by EVGENIY DAN on 19.03.2022.
//

import SwiftUI

struct ProductsView: View {
    @StateObject var products: Load<Product>
    

    @Binding var productShowView: ProductShowView
    
    var body: some View {
        
        let countGrid = Int(UIScreen.main.bounds.width/170)
        let restWidth = Int(UIScreen.main.bounds.width) % 170
        let restWidthWithoutSpacing = restWidth - (10 * countGrid) - 15
        let widthItem = CGFloat(170+(restWidthWithoutSpacing/countGrid))
        
        let columns: [GridItem] = .init(repeating: GridItem(.fixed(widthItem), spacing: 10), count: countGrid)
        
        
        
        ScrollView {
            
            
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 20,
                pinnedViews: [.sectionHeaders]
            ) {
                ForEach(0..<self.products.elements.count, id: \.self) { i in
                    let product = self.products.elements[i]
                    ZStack {
                        Button(action: {
                            
                            if product.value["type_id"] == "section" {
                                let url = "/api/s/" + (product.value["url"] ?? "section pathUrl error")
                                self.productShowView = .section(pathUrl: url, header: product.value["h1"])
                            } else {
                                let url = "/api/p/" + (product.value["url"] ?? "section pathUrl error")
                                self.productShowView = .product(pathUrl: url, header: product.value["h1"], productId: UUID(uuidString: product.value["id"] ?? "") ?? UUID())
                            }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showProductView"), object: nil)
                        }) {
                            if product.value["type_id"] == "section" {
                                SectionCard(productId: UUID(uuidString: product.value["id"] ?? "") ?? UUID(),
                                            productName: product.value["h1"] ?? "",
                                            imagePath: product.value["photo"] ?? "", 
                                            width: widthItem)
                                    .cornerRadius(10)
                                    .shadow(color: .shadowCard, radius: 2, x: 3, y: 3)
                            } else {
                                ProductCard(productId: UUID(uuidString: product.value["id"] ?? "") ?? UUID(),
                                            productName: product.value["h1"] ?? "",
                                            imagePath: product.value["photo"] ?? "",
                                            price: product.value["price"] ?? "0", 
                                            width: widthItem)
                                    .cornerRadius(10)
                                    .shadow(color: .shadowCard, radius: 2, x: 3, y: 3)
                            }
                        }
                        
                        
                    }
                    
                    .frame(width: widthItem, height: 200)
                    
                }
                
            }
            .padding(.vertical)
            
        }
//        .listStyle(GroupedListStyle())
//        .listStyle(PlainListStyle()) // Убирает отступы белые вокруг List
        .onAppear {
            products.get()
        }
        
    }
}

struct ProductsView_Previews: PreviewProvider {
    var products: Load<Product>
    @State var productShowView: ProductShowView = .none
    
    init() {
        self.products = Load<Product>()
        var sectionProduct = Product()
        sectionProduct.value["type_id"] = "section"
        products.elements.append(Product())
        products.elements.append(sectionProduct)
        products.elements.append(sectionProduct)
        products.elements.append(Product())
        products.elements.append(Product())
        products.elements.append(sectionProduct)
        products.elements.append(Product())
    }
    
    static var previews: some View {
        ProductsView(products: Self().products,
                     productShowView: Self().$productShowView)
            
    }
    
}
