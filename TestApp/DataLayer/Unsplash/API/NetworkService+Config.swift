//
//  NetworkService+Config.swift
//  TestApp
//
//  Created by Vadim Kozachenko on 29.10.21.
//

import Foundation

extension NetworkService {

    struct Config {
        let accessKey = "c52oEzPFupWB_UKFgiMZqdef8fnO7_To-d1ukXHygDE"
        let secretKey = "iVf3dBQzKLOUCfYjHwbc89ZRJ6J-pvSkU2taEkul_Xs"
        let apiURL = "https://api.unsplash.com/"
        let photosEndpoint = "photos"
        let editorialCollectionId = "317099"
        let collectionId = "317099"
        var collections: String {
            "collections/\(collectionId)/photos"
        }
    }
}
