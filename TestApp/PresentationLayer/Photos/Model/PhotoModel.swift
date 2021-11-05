//
//  Model.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 3.11.21.
//

import UIKit

struct PhotoModel {
    let imageURL: URL?
    let width: Float
    let height: Float
    let likesCount: Int
    var image: UIImage?
    let color: UIColor

    init(dto: UnsplashPhotoDTO) {
        self.imageURL = URL(string: dto.urls.regular)
        self.width = Float(dto.width)
        self.height = Float(dto.height)
        self.likesCount = dto.likes
        self.color = UIColor(hexString: dto.color)
    }
}
