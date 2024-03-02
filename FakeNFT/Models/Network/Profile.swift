//
//  Profile.swift
//  FakeNFT
//
//  Created by Эмилия on 27.02.2024.
//

import Foundation

struct Profile: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
