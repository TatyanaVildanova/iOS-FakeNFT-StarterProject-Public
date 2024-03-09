//
//  OrderService.swift
//  FakeNFT
//
//  Created by Эмилия on 28.02.2024.
//

import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

//MARK: - OrderService
protocol OrderService {
    func loadOrders(completion: @escaping OrderCompletion)
    func setOrders(id: String, orders: [String], completion: @escaping OrderCompletion)
}

//MARK: - OrderServiceImpl
final class OrderServiceImpl: OrderService {
    
    //MARK: - Private properties
    private let networkClient: NetworkClient
    
    // MARK: - Initializers
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        loadOrders { _ in }
    }
    
    // MARK: - Methods
    func loadOrders(completion: @escaping OrderCompletion) {
        let request = OrderRequest()
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setOrders(id: String, orders: [String], completion: @escaping OrderCompletion) {
        let request = OrderPutRequest(id: id, orders: orders)
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

