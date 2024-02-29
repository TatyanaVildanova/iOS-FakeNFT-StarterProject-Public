import Foundation

final class SetLikesRequest: NetworkRequest {
    var httpMethod: HttpMethod
    var dto: Encodable?
    var endpoint: URL? {
        URL(string: "https://\(Constants.host.rawValue)/api/v1/profile/\(id)")
    }
    private var id: String
    
    init(httpMethod: HttpMethod, id: String, likes: [String: [String]]) {
        self.httpMethod = httpMethod
        self.id = id
        self.dto = likes
    }
}
