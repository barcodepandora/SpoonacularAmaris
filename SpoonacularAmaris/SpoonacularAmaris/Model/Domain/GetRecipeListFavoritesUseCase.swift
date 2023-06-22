//
//  GetRecipeListFavoritesUseCase.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 21/06/23.
//

import Foundation
import FirebaseFirestore

class GetRecipeListFavoritesUseCase {
    func fetchRecipeList(completion: @escaping ([Recipe.Response]?, Error?) -> Void) {
        Firestore.firestore().collection("Recipes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var modelList: [Recipe.Response] = []
                var recipe: Recipe.ViewModel
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    modelList.append(Recipe.Response(id: document.data().filter { $0.key == "id"}["id"] as! Int,
                                    title: document.data().filter { $0.key == "title"}["title"] as! String,
                                    image: document.data().filter { $0.key == "image"}["image"] as! String as! String,
                                    imageType: document.data().filter { $0.key == "imageType"}["imageType"] as! String))
                }
                completion(modelList, nil)
            }
        }
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
