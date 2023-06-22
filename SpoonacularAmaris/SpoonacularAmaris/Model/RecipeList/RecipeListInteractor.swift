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

    func requestRecipeList() {
        GetRecipeListUseCase().fetchRecipeList( completion: { (response, error) in
            if let response = response {
                self.presenter!.presentRecipeList(modelList: self.fromResponseToViewModel(response: response))
            } else if let error = error {
                self.presenter!.presentError(error: error)
            }
        })
    }
    
    func fromResponseToViewModel(response: [Recipe.Response]) -> [Recipe.ViewModel] {
        var modelList: [Recipe.ViewModel] = []
        for recipe in response {
            modelList.append(Recipe.ViewModel(id: recipe.id,
                                              title: recipe.title,
                                              image: recipe.image,
                                              imageType: recipe.imageType))
        }
        return modelList
    }
    
    func requestRecipeListFavorites() {
        GetRecipeListFavoritesUseCase().fetchRecipeList( completion: { (response, error) in
            if let response = response {
                self.presenter!.presentRecipeListFavorites(modelList: self.fromResponseToViewModel(response: response))
            } else if let error = error {
                self.presenter!.presentError(error: error)
            }
        })
    }
}
