//
//  RecipeService.swift
//  Fetch Take Home
//
//  Created by Austin Burgess on 6/12/25.
//

import Foundation

class RecipeService: ObservableObject {
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    
    enum Endpoint {
        case recipes
        case malformed
        case empty
        
        var url: URL? {
            let base = "https://d3jbb8n5wk0qxi.cloudfront.net"
            switch self {
            case .recipes:
                return URL(string: "\(base)/recipes.json")
            case .malformed:
                return URL(string: "\(base)/recipes-malformed.json")
            case .empty:
                return URL(string: "\(base)/recipes-empty.json")
            }
        }
    }
    
    enum RecipeError: Error, LocalizedError {
        case invalidURL
        case noData
        case decodingError
        case networkError(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .noData:
                return "No data recieved"
            case .decodingError:
                return "Failed to decode recipes"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchRecipes(from endpoint: Endpoint = .recipes) async throws -> [Recipe] {
        guard let url = endpoint.url else {
            throw RecipeError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(RecipesResponse.self, from: data)
            return response.recipes
        } catch {
            if error is DecodingError {
                throw RecipeError.decodingError
            } else {
                throw RecipeError.networkError(error)
            }
        }
    }
}
