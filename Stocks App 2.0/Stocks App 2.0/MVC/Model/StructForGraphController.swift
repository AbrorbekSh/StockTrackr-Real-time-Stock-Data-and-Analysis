import Foundation


struct StructForGraphController {
    let name: String
    let ticker: String
    let price: String
    let difference: String
    let favourite: Bool
    
//    let day: GraphData
//    let week: GraphData
//    let month: GraphData
//    let halfYear: GraphData
//    let year: GraphData
}

struct GraphData: Decodable{
    let c: [Double]
}
