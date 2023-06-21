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
        APIClient.request( completion: { (response) in
            debugPrint(response)
            self.vc!.presentRecipeList(resultsDecodable: response)
        })
    }
}
