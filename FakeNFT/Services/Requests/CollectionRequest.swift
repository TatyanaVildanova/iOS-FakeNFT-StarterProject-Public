//
//  CollectionRequest.swift
//  FakeNFT
//
//  Created by Эмилия on 16.02.2024.
//

import Foundation

//MARK: - CollectionsRequest
struct CollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
}
