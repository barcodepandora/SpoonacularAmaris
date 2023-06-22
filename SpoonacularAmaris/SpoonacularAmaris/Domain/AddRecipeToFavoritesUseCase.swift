//
//  AddRecipeToFavoritesUseCase.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 21/06/23.
//

import Foundation
import FirebaseFirestore

class AddRecipeToFavoritesUseCase {
    func addToFavorites(recipe: Recipe.Request) {
        let collection = Firestore.firestore().collection("Recipes")
        let recipeData = RecipeData(
            id: recipe.id,
            title: recipe.title,
            image: recipe.image,
            imageType: recipe.imageType
        )
        collection.addDocument(data: recipeData.dictionary)
    }
}
