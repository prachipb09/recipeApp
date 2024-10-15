//
//  NetworkLayer.swift
//  Recipe App
//
//  Created by Prachi Bharadwaj on 14/10/24.
//

import Foundation

enum RecipeError: Error {
    case NetworkError
}

enum RecipeHTTPSMethods: String, Equatable {
    case get = "GET"
    case post = "POST"
}

enum RequestType {
    case RecipeLandingPage
    
    var httpMethod: RecipeHTTPSMethods {
        switch self {
            case .RecipeLandingPage:
                    .get
        }
    }
    
    var path: String {
        switch self {
            case .RecipeLandingPage:
                "/recipes.json"
        }
    }
}

class NetworkLayer {
    static let shared = NetworkLayer()
    
    private init() { }
    
    func decode<T: Codable>(modelType: T.Type, for dataType: RequestType) async throws -> T {
        guard let url = URL(string: "\(Environment.baseUrl)"+"\(dataType.path)" ) else {
            throw RecipeError.NetworkError
        }
        
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .returnCacheDataElseLoad,
                                    timeoutInterval: 10.0)
        urlRequest.httpMethod = dataType.httpMethod.rawValue
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let values =  try JSONDecoder().decode(modelType, from: data)
            return values
        } catch {
            throw error
        }
    }
}
