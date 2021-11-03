//
//  URLImageCache.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 30.10.21.
//

import Foundation

final class URLCacheManager {

    static let shared = URLCacheManager()

    private let cache = URLCache(
        memoryCapacity: memoryCapacity,
        diskCapacity: diskCapacity,
        diskPath: diskPath
    )
    private static let diskPath = "unsplash"
    private static let memoryCapacity = 50.megabytes
    private static let diskCapacity = 100.megabytes

    func response(for url: URL) -> CachedURLResponse? {
        cache.cachedResponse(for: URLRequest(url: url))
    }

    func store(response: CachedURLResponse, for url: URL) {
        cache.storeCachedResponse(response, for: URLRequest(url: url))
    }

    func removeResponse(for url: URL) {
        cache.removeCachedResponse(for: URLRequest(url: url))
    }

    func removeAllResponses() {
        cache.removeAllCachedResponses()
    }
}

private extension Int {
    var megabytes: Int { self * 1024 * 1024 }
}
