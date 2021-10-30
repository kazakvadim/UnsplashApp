//
//  PhotosViewModel.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 22.10.21.
//

import UIKit

class PhotoModel {
    let imageURL: URL?
    let width: Float
    let height: Float
    let likesCount: Int
    var image: UIImage?

    init(model: UnsplashPhoto) {
        self.imageURL = URL(string: model.urls.regular)
        self.width = Float(model.width)
        self.height = Float(model.height)
        self.likesCount = model.likes
    }
}

class PhotosViewModel {

    private let networkService = UnsplashNetworkService.shared
    var dataSource: [PhotoModel] = []

    func downloadData(completion: @escaping () -> Void) {
        networkService.download { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(items):
                self.dataSource = items.map { PhotoModel(model: $0) }
                completion()
            case let .failure(error):
                print(error)
            }
        }
    }
}
