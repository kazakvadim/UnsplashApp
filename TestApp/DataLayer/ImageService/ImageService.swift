//
//  UIImageLoader.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 28.10.21.
//

import UIKit

final class ImageService {

    static let shared = ImageService()

    typealias ImageCallback = ((UIImage?, Bool) -> Void)

    private let imageLoader = ImageDownLoader()
    private var requestsMap = [UIImageView: UUID]()

    private init() {}

    func load(_ url: URL, for imageView: UIImageView, completion: @escaping ImageCallback) {
        let token = imageLoader.loadImage(url) { [weak self] result in
            guard let self = self else { return }
            defer { self.requestsMap.removeValue(forKey: imageView) }

            DispatchQueue.main.async {
                switch result {
                case let .success((image, isCached)):
                    completion(image, isCached)
                case let .failure(error):
                    completion(nil, false)
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
        ImageService.shared.load(url, for: self) { [weak self] image, isCached in
            guard let self = self else { return }
            self.setImage(image ?? placeholder, isCached: isCached, completion: {
                completion?(self.image)
            })
        }
    }

    private func setImage(
        _ image: UIImage?,
        isCached: Bool,
        completion: @escaping (() -> Void)
    ) {
        guard !isCached else {
            self.image = image
            completion()
            return
        }
        UIView.transition(with: self, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.image = image
        }, completion: { _ in
            completion()
        })
    }

    func cancelLoad() {
        ImageService.shared.cancel(for: self)
    }
}
