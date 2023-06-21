//
//  RecipeListInteractor.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 21/06/23.
//

import Foundation

class RecipeListInteractor {
    var presenter: RecipeListPresenter?
    
    init(presenter: RecipeListPresenter) {
        self.presenter = presenter
    }

    func request() {
        APIClient.requestRecipeList( completion: { (response, error) in
            if let response = response {
                self.presenter!.presentRecipeList(modelList: self.fromDecodableRoModel(response: response))
//                self.vc!.presentRecipeList(resultsDecodable: response)
            } else if let error = error {
                self.presenter!.presentError(error: error)
            }
        })
    }
    
    func fromDecodableRoModel(response: ResultsDecodable) -> [Recipe.ViewModel] {
        var modelList: [Recipe.ViewModel] = []
        for recipe in response.results! {
            modelList.append(Recipe.ViewModel(id: recipe.id!,
                                              title: recipe.title!,
                                              image: recipe.image!,
                                              imageType: recipe.imageType!))
        }
        return modelList
    }
}
