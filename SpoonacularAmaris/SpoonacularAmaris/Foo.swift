//
//  Foo.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 20/06/23.
//

import Foundation
//import Alamofire

class Foo {
    var vc: RecipeListViewController?
    
    init(vc: RecipeListViewController) {
        self.vc = vc
    }
    
    func request() {
        APIClient.requestRecipeList( completion: { (response, error) in
            if let response = response {
                self.vc!.presentRecipeList(resultsDecodable: response)
            } else if let error = error {
                self.vc!.presentError(error: error)
            }
        })
    }
}
