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
    func cartState(for id:String) -> Bool
}

//MARK: - OrderServiceImpl
final class OrderServiceImpl: OrderService {
    
    //MARK: - Private properties
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    // MARK: - Initializers
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.networkClient = networkClient
        self.storage = storage
        loadOrders { _ in }
    }
    
    // MARK: - Methods
    func loadOrders(completion: @escaping OrderCompletion) {
        let request = OrderRequest()
        networkClient.send(request: request, type: Order.self) { [weak storage] result in
            switch result {
            case .success(let orders):
                storage?.saveOrderId(orderId: orders.id)
                orders.nfts.forEach {
                    storage?.saveOrders($0)
                }
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cartState(for id: String) -> Bool {
        storage.findInOrders(id)
    }
}

