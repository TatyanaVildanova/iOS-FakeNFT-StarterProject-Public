import Foundation

struct Nft: Decodable {
    private let createdAt: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
    
    var createAtDate: Date {
        DateFormatter.defaultDateFormatter.date(from: createdAt)!
    }
}
