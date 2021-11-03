//
//  NetworkService.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 29.10.21.
//

import Alamofire

enum NetworkError: Error {
    case error(message: String)
}

final class NetworkService {

    static let shared = NetworkService()
    private let networkProvider = UnsplashAPI.provider
    private let config = Config()

    func downloadImages(for cursor: UnsplashCursor, completion: @escaping (Result<[UnsplashPhotoDTO], NetworkError>) -> Void) {
        networkProvider.request(UnsplashAPI.getPhotos(collectionId: config.collectionId, cursor: cursor)) { result in
            switch result {
            case let .success(response):
                let data = response.data
                let decoder = JSONDecoder()
                do {
                    let images = try decoder.decode([UnsplashPhotoDTO].self, from: data)
                    completion(.success(images))
                } catch {
                    completion(.failure(.error(message: error.localizedDescription)))
                }
            case let .failure(error):
                print("Moya error \(error.localizedDescription)")
            }
        }
    }
    
}
