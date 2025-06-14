//
//  DetailRecipeView.swift
//  Fetch Take Home
//
//  Created by Austin Burgess on 6/14/25.
//

import SwiftUI

struct DetailRecipeView: View {
//    @StateObject var viewModel = RecipeListViewModel()
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            
            CachedAsyncImage(
                url: recipe.photoUrlLarge,
                width: 300,
                height: 300
            )
            
            VStack(alignment: .center, spacing: 8) {
                Text(recipe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text(recipe.cuisine)
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                if let sourceUrl = recipe.sourceUrl {
                    Link("View Recipe", destination: URL(string: sourceUrl)!)
                        .buttonStyle(.borderedProminent)
                }
                
                if let youtubeUrl = recipe.youtubeUrl {
                    Link("Watch Video", destination: URL(string: youtubeUrl)!)
                        .buttonStyle(.bordered)
                }
    
            }
            
        }
    }
}

// Preview for development
#Preview {
    DetailRecipeView(recipe: Recipe(
        uuid: "test-id",
        name: "Banana Pancakes",
        cuisine: "American",
        photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg",
        photoUrlSmall: nil,
        sourceUrl: "https://www.bbcgoodfood.com/recipes/banana-pancakes",
        youtubeUrl: "https://www.youtube.com/watch?v=kSKtb2Sv-_U"
    ))
    .previewLayout(.sizeThatFits)
    .padding()
}
