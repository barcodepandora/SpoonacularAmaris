//
//  GetRecipeListUseCase.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 21/06/23.
//

import Foundation

class GetRecipeListUseCase {
    func fetchRecipeList(completion: @escaping ([Recipe.Response]?, Error?) -> Void) {
        APIClient.requestRecipeList(completion: { (response, error) in
            if let response = response {
                completion(self.fromDecodableToResponse(response: response), nil)
            } else if let error = error {
                completion(nil, error)
            }
        })
    }
    
    func fromDecodableToResponse(response: ResultsDecodable) -> [Recipe.Response] {
        var modelList: [Recipe.Response] = []
        for recipe in response.results! {
            modelList.append(Recipe.Response(id: recipe.id!,
                                              title: recipe.title!,
                                              image: recipe.image!,
                                              imageType: recipe.imageType!))
        }
        return modelList
    }
}
