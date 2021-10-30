//
//  ImageLoader.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 28.10.21.
//

import UIKit

class ImageLoader {

    private var activeRequests = [UUID: URLSessionDataTask]()
    private let cache = ImageCache()

    func loadImage(_ url: URL?, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        guard let url = url else {
            return nil
        }

        if let image = cache[url] {
            completion(.success(image))
            return nil
        }
        let uuid = UUID()
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer { self.activeRequests.removeValue(forKey: uuid) }
            if let data = data, let image = UIImage(data: data) {
                self.cache[url] = image
                completion(.success(image))
                return
            }
            guard let error = error else { return }
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        task.resume()

        activeRequests[uuid] = task
        return uuid
    }

    func cancelLoad(_ uuid: UUID) {
        activeRequests[uuid]?.cancel()
        activeRequests.removeValue(forKey: uuid)
    }
}
