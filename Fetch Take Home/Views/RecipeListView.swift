//
//  RecipeListView.swift
//  Fetch Take Home
//
//  Created by Austin Burgess on 6/12/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    Text("Loading tasty recipes...😋")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)\nTry again later")
                } else {
                    List(viewModel.recipes) { recipe in
                        NavigationLink(destination: DetailRecipeView(recipe: recipe)) {
                            RecipeRowView(recipe: recipe)
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.loadRecipes()
            }
            .navigationTitle("Recipes")
        }
        .task {
            await viewModel.loadRecipes()
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }
}
