//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Эмилия on 28.02.2024.
//

import Foundation

//MARK: - ProfileRequest
struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}
