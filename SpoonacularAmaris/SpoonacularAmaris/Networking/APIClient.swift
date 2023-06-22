//
//  APIClient.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 20/06/23.
//

import Foundation
import Alamofire

class APIClient {
    static var isInternetAvailable: Bool {
        return NetworkReachabilityManager()!.isReachable
    }

    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return JSONDecoder()
    }()

    static func requestRecipeListMock(completion: @escaping (ResultsDecodable?, Error?) -> Void) {
        if !self.isInternetAvailable {
            completion(nil, NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Internet KO"]))
        } else {
            AF.request("https://api.spoonacular.com/recipes/complexSearch?apiKey=f4a136efeb214d70a875a56f418b162e")
            .responseDecodable(of: ResultsDecodable.self, decoder: decoder) { response in
                switch response.result {
                    case .success(let value):
                        if value.results == nil || value.results!.isEmpty {
                            completion(nil, NSError(domain: "", code: -1234, userInfo: [ NSLocalizedDescriptionKey: "Data 0"]))
                        } else {
                            completion(value, nil)
                        }
                    case .failure(let error):
                        completion(nil, error)
                }
            }
        }
    }
    
    static func requestRecipeList(completion: @escaping (ResultsDecodable?, Error?) -> Void) {
        if !self.isInternetAvailable {
            completion(nil, NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Internet KO"]))
        } else {
            AF.request(APIRouter.recipes)
            .responseDecodable(of: ResultsDecodable.self, decoder: decoder) { response in
                switch response.result {
                    case .success(let value):
                        if value.results == nil || value.results!.isEmpty {
                            completion(nil, NSError(domain: "", code: -1234, userInfo: [ NSLocalizedDescriptionKey: "Data 0"]))
                        } else {
                            completion(value, nil)
                        }
                    case .failure(let error):
                        completion(nil, error)
                }
            }
        }
    }
}
