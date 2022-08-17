import Foundation

struct ProfileURL: Decodable {
    var name: String
    var logo: String
}

struct QuoteURL: Decodable{
    var c: Double // current price
    var d: Double // change
    var dp: Double// change in percent
}
