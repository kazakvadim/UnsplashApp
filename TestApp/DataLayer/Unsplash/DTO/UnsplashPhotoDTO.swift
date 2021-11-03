//
//  UnsplashPhoto.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 29.10.21.
//

import Foundation

struct UnsplashPhotoDTO: Codable {

    struct Urls: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }

    let id: String
    let likes: Int
    let width: Int
    let height: Int
    let urls: Urls
}

