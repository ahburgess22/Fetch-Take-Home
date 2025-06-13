//
//  RecipeListViewModel.swift
//  Fetch Take Home
//
//  Created by Austin Burgess on 6/12/25.
//

import SwiftUI

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showAlert: Bool = false
    let recipeService = RecipeService()
    private var loadTask: Task<Void, Never>? // Track current task
    
    func loadRecipes() async {
        
        loadTask?.cancel()
        
        loadTask = Task {
            
            isLoading = true
            errorMessage = nil
            showAlert = false
            do {
                try Task.checkCancellation() // Check for cancellation
                try await Task.sleep(nanoseconds: 2_000_000_000)
                try Task.checkCancellation() // Check again after sleep
                
                let fetchedRecipes = try await recipeService.fetchRecipes()
                if !Task.isCancelled {
                    self.recipes = fetchedRecipes
                    self.isLoading = false
                }
            } catch is CancellationError { // Task was cancelled, don't update UI
                return
            }
            catch {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
                self.isLoading = false
            }
        }
        await loadTask?.value
    }
}
