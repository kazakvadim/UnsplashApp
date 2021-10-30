//
//  ImageDownLoader.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 28.10.21.
//

import UIKit

class ImageDownLoader {

    private var activeRequests = [UUID: URLSessionDataTask]()
    private let cache = URLCacheManager.shared

    func loadImage(_ url: URL?, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        guard let url = url else {
            return nil
        }

        if let response = cache.response(for: url),
           let image = UIImage(data: response.data) {
            completion(.success(image))
            return nil
        }
        let uuid = UUID()
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer { self.activeRequests.removeValue(forKey: uuid) }
            if let data = data,
               let image = UIImage(data: data),
               let response = response {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                self.cache.store(response: cachedResponse, for: url)
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
