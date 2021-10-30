//
//  UIImageLoader.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 28.10.21.
//

import UIKit

final class ImageService {

    static let shared = ImageService()

    typealias ImageCallback = ((UIImage?) -> Void)

    private let imageLoader = ImageLoader()
    private var requestsMap = [UIImageView: UUID]()
    private var callbacks = [URL: [ImageCallback]]()

    private init() {}

    func load(_ url: URL, for imageView: UIImageView, completion: @escaping ImageCallback) {
        callbacks[url]?.append(completion)

        let token = imageLoader.loadImage(url) { [weak self] result in
            guard let self = self else { return }
            defer { self.requestsMap.removeValue(forKey: imageView) }

            DispatchQueue.main.async {
                switch result {
                case let .success(image):
                    self.callbacks[url]?.forEach { $0(image) }
                case let .failure(error):
                    self.callbacks[url]?.forEach { $0(nil) }
                    print("Error \(error.localizedDescription)")
                }
            }
        }
        if let token = token {
            requestsMap[imageView] = token
        }
    }

    func cancel(for imageView: UIImageView) {
        guard let uuid = requestsMap[imageView] else { return }

        imageLoader.cancelLoad(uuid)
        requestsMap.removeValue(forKey: imageView)
    }
}

extension UIImageView {

    func setImage(
        url: URL?,
        placeholder: UIImage? = nil,
        completion: ((UIImage?) -> Void)? = nil
    ) {
        guard let url = url else {
            self.image = placeholder
            completion?(self.image)
            return
        }
        ImageService.shared.load(url, for: self) { image in
            self.image = image ?? placeholder
            completion?(self.image)
        }
    }

    func cancelLoad() {
        ImageService.shared.cancel(for: self)
    }
}
