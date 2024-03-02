//
//  Order.swift
//  FakeNFT
//
//  Created by Эмилия on 27.02.2024.
//

import Foundation

struct Order: Codable {
    let nfts: [String]
    let id: String
}
