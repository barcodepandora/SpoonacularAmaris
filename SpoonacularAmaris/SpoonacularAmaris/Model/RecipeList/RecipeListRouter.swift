//
//  RecipeListRouter.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 21/06/23.
//

import Foundation

class RecipeListRouter {
    func routeToRecipe(from: RecipeListViewController, to: RecipeViewController) {
        from.navigationController?.pushViewController(to, animated: true)
    }
    
    func routeToFavorites(from: RecipeListViewController, to: RecipeListViewController) {
        from.navigationController?.pushViewController(to, animated: true)
    }

}
