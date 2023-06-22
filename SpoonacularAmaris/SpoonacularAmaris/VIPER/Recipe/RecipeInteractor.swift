//
//  RecipeInteractor.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 21/06/23.
//

import Foundation

class RecipeInteractor {
    func addToFavorites(recipe: Recipe.Request) {
        AddRecipeToFavoritesUseCase().addToFavorites(recipe: recipe)
    }
}
