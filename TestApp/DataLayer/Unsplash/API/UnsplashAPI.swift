//
//  UnsplashAPI.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 3.11.21.
//

import Moya

enum UnsplashAPI {
    case getPhotos(collectionId: String, cursor: UnsplashCursor)
}

extension UnsplashAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://api.unsplash.com")!
    }

    var path: String {
        switch self {
        case let .getPhotos(collectionId, _):
            return "/collections/\(collectionId)/photos"
        }
    }

    var method: Method {
        switch self {
        case .getPhotos:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .getPhotos(_, cursor):
            var parameters = [String: Any]()
            parameters["per_page"] = cursor.perPage
            parameters["page"] = cursor.page
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getPhotos:
            let headers = ["Authorization": "Client-ID c52oEzPFupWB_UKFgiMZqdef8fnO7_To-d1ukXHygDE"]
            return headers
        }
    }
}

extension UnsplashAPI {
    static let provider = MoyaProvider<UnsplashAPI>()
}
