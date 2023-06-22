//
//  Recipe.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 21/06/23.
//

import Foundation

enum Recipe {
    struct Request {
        var id: Int
        var title: String
        var image: String
        var imageType: String
    }
    
    struct Response {
        var id: Int
        var title: String
        var image: String
        var imageType: String
    }
    
    struct ViewModel {
        var id: Int
        var title: String
        var image: String
        var imageType: String
    }
}

struct RecipeData {
    var id: Int?
    var title: String?
    var image: String?
    var imageType: String?
    var dictionary: [String: Any] {
        return ["id": id,
                "title": title,
                "image": image,
                "imageType": imageType]
    }
}
