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

//MARK: - OrdersPutRequest
struct OrderPutRequest: NetworkRequest {
    
    //MARK: - Properties
    let httpMethod: HttpMethod = .put
    var id: String
    var orders: [String]
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var body: Data? {
        return ordersToString().data(using: .utf8)
    }
    
    // MARK: - Initializers
    init(id: String, orders: [String]) {
        self.orders = orders
        self.id = id
    }
    
    // MARK: - Private methods
    private func ordersToString() -> String {
        var ordersString = "nfts="
        if orders.isEmpty {
            ordersString += ""
        } else {
            for (index, order) in orders.enumerated() {
                ordersString += order
                if index != orders.count - 1 {
                    ordersString += "&nfts="
                }
            }
        }
        ordersString += "&id=\(id)"
        return ordersString
    }
}
