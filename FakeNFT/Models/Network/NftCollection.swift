//
//  NftCollection.swift
//  FakeNFT
//
//  Created by Эмилия on 16.02.2024.
//

import Foundation

struct NftCollection: Codable {
    private let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
    
    var createAtDate: Date {
        DateFormatter.defaultDateFormatter.date(from: createdAt)!
    }
    //    var coverURL: URL { URL(string: cover)! }
    
    var coverURL: URL {
        URL(string: cover.encodeURL)!
    }
    
}



