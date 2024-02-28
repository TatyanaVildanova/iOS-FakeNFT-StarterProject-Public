//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Эмилия on 28.02.2024.
//

import Foundation

//MARK: - OrderRequest
struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
