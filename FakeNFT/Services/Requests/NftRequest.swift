import Foundation

//MARK: - ProfileRequest
struct NFTRequest: NetworkRequest {
    
    //MARK: - Properties
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
