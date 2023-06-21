//
//  APIClient.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 20/06/23.
//

import Foundation
import Alamofire

class APIClient {
    
//    static func request(completion: @escaping (Result<ResultsDecodable, AFError>) -> Void) {
    static func request(completion: @escaping (ResultsDecodable) -> Void) {

//    static func request() {
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()

        AF.request("https://api.spoonacular.com/recipes/complexSearch?apiKey=f4a136efeb214d70a875a56f418b162e")
        .responseDecodable(of: ResultsDecodable.self, decoder: decoder) { response in
            debugPrint(response)
//            completion(response.result)
            completion(response.value!)
        }

    }

}
