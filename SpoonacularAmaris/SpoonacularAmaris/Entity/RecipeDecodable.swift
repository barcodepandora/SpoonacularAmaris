//
//  RecipeDecodable.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 20/06/23.
//

import Foundation

class RecipeDecodable: Decodable{
    var id: Int?
    var title: String?
    var image: String?
    var imageType: String?
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case title = "title"
        case image = "image"
        case imageType = "imageType"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        imageType = try values.decodeIfPresent(String.self, forKey: .imageType)
    }
}
