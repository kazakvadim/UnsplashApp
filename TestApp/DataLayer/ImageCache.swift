//
//  ImageCache.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 29.10.21.
//

import UIKit

final class ImageCache {

    private let cachedImages = NSCache<NSURL, UIImage>()

    subscript(_ url: URL) -> UIImage? {
        get {
            return image(withKey: url)
        }
        set {
            return insertImage(newValue, withKey: url)
        }
    }

    private func image(withKey url: URL) -> UIImage? {
        cachedImages.object(forKey: url as NSURL)
    }

    func insertImage(_ image: UIImage?, withKey url: URL) {
        guard let image = image else {
            return removeImage(withKey: url)
        }

        cachedImages.setObject(image, forKey: url as NSURL)
    }

    func removeImage(withKey url: URL) {
        cachedImages.removeObject(forKey: url as NSURL)
    }
}
