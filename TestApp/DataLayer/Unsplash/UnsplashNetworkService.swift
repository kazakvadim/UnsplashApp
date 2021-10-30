//
//  UnsplashNetworkService.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 29.10.21.
//

import Alamofire

enum NetworkError: Error {
    case error(message: String)
}

final class UnsplashNetworkService {

    static let shared = UnsplashNetworkService()
    private let config = Config()

    func download(completion: @escaping (Result<[UnsplashPhoto], NetworkError>) -> Void) {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(config.accessKey)"
        let url = URL(string: "https://api.unsplash.com/photos/")!
        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .responseJSON {
                guard let data = $0.data else { assertionFailure(); return }
                let decoder = JSONDecoder()
                do {
                    let images = try decoder.decode([UnsplashPhoto].self, from: data)
                    completion(.success(images))
                } catch {
                    completion(.failure(.error(message: error.localizedDescription)))
                }
            }
    }
    
}
