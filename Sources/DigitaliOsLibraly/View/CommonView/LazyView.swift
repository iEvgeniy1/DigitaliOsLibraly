//
//  LazyView.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 04.07.2020.
//  Copyright © 2020 EVGENIY DAN. All rights reserved.
//

import SwiftUI

// Нужно для того чтобы  навигационные ссылки не загружались без нажатия на них. Иначи будет поступать очень много запросов на сервер!
struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        //print("LazyView")
        self.build = build
    }
    var body: Content {
        build()
    }
}
