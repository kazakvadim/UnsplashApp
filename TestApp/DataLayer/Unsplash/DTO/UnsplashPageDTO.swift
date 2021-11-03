//
//  UnsplashPageDTO.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 3.11.21.
//

import Foundation

class UnsplashCursor {
    var page: Int
    let perPage: Int

    init(page: Int, perPage: Int) {
        self.page = page
        self.perPage = perPage
    }
}
