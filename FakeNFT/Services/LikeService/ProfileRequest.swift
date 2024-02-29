import Foundation

final class ProfileRequest: NetworkRequest {
    var httpMethod: HttpMethod
    var endpoint: URL? {
        URL(string: "https://\(Constants.host.rawValue)/api/v1/profile/\(id)")
    }
    private var id: String
    
    init(httpMethod: HttpMethod, id: String) {
        self.httpMethod = httpMethod
        self.id = id
    }
}
