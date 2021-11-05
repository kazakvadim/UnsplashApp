//
//  PhotosViewModel.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 22.10.21.
//

import Combine

class PhotosViewModel {

    private let networkService = NetworkService.shared
    private(set) var dataSource: [PhotoModel] = []
    private var cursor = UnsplashCursor(page: 1, perPage: 5)
    private var canFetchMore = true
    private var isRequestPerforming = false

    private let _contentChangesPublisher = PassthroughSubject<[PhotoModel], Never>()
    var contentChangesPublisher: AnyPublisher<[PhotoModel], Never> {
        _contentChangesPublisher
            .eraseToAnyPublisher()
    }

    func downloadData(completion: (() -> Void)? = nil) {
        networkService.downloadImages(for: cursor) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(items):
                let photos = items.map { PhotoModel(dto: $0) }
                self.handle(items: photos)
            case let .failure(error):
                self.handle(error: error)
            }
            self.contentDidChange()
            completion?()
        }
    }

    private func contentDidChange() {
        _contentChangesPublisher.send(dataSource)
    }

    private func handle(items: [PhotoModel]) {
        if items.count < cursor.perPage {
            canFetchMore = false
        } else {
            cursor.page += 1
        }
        dataSource.append(contentsOf: items)
    }

    private func handle(error: Error) {
        print(error.localizedDescription)
    }

    func downloadNextItems() {
        guard canFetchMore, !isRequestPerforming else { return }

        isRequestPerforming = true
        downloadData { [weak self] in
            self?.isRequestPerforming = false
        }
    }
}
