//
//  RecipeRowView.swift
//  Fetch Take Home
//
//  Created by Austin Burgess on 6/12/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 12) {
            
            CachedAsyncImage(
                url: recipe.photoUrlSmall,
                width: 60,
                height: 60
            )
            
            // Recipe info
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// Preview for development
#Preview {
    RecipeRowView(recipe: Recipe(
        uuid: "test-id",
        name: "Bakewell Tart",
        cuisine: "British",
        photoUrlLarge: nil,
        photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
        sourceUrl: nil,
        youtubeUrl: nil
    ))
    .previewLayout(.sizeThatFits)
    .padding()
}
