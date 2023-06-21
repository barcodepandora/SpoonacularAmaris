//
//  ResultsDecodable.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 20/06/23.
//

import Foundation

class ResultsDecodable: Decodable{
    var results: [RecipeDecodable]?
    
    enum CodingKeys: String, CodingKey{
        case results = "results"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try? values.decode([RecipeDecodable].self, forKey: .results)
    }
//
//    public init(data: [UserDecodable]) {
//        self.data = data
//    }
}
