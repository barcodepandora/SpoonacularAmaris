//
//  APIRouter.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 22/06/23.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case recipes
    
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .recipes:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .recipes:
            return "/complexSearch"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .recipes:
            return [APIConstants.APIParameterKey.apiKey: "f4a136efeb214d70a875a56f418b162e"]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try APIConstants.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        return try URLEncoding.default.encode(urlRequest,with: parameters)
    }
}

