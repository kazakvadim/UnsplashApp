//
//  UIImageLoader.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 28.10.21.
//

import UIKit

final class ImageService {

    static let shared = ImageService()

    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()

    private init() {}

    func load(_ url: URL, for imageView: UIImageView) {
        let token = imageLoader.loadImage(url) { result in
            defer { self.uuidMap.removeValue(forKey: imageView) }
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch {

            }
        }
        if let token = token {
            uuidMap[imageView] = token
        }
    }

    func cancel(for imageView: UIImageView) {
        guard let uuid = uuidMap[imageView] else { return }

        imageLoader.cancelLoad(uuid)
        uuidMap.removeValue(forKey: imageView)
    }
}

extension UIImageView {
    func loadImage(at url: URL) {
        ImageService.shared.load(url, for: self)
    }

    func cancelImageLoad() {
        ImageService.shared.cancel(for: self)
    }
}
