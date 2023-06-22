//
//  RecipeListPresenter.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 21/06/23.
//

import Foundation

class RecipeListPresenter {
    var vc: RecipeListViewController?
    
    init(vc: RecipeListViewController) {
        self.vc = vc
    }
    
    func presentRecipeList(modelList: [Recipe.ViewModel]) {
        self.vc!.presentRecipeList(modelList: modelList)
    }
    
    func presentRecipeListFavorites(modelList: [Recipe.ViewModel]) {
        self.vc!.presentRecipeListFavorites(modelList: modelList)
    }
    
    func presentError(error: Error) {
        self.vc!.presentError(error: error)
    }
}
