//
//  Fetch_Take_HomeTests.swift
//  Fetch Take HomeTests
//
//  Created by Austin Burgess on 6/12/25.
//

import XCTest
@testable import Fetch_Take_Home

final class Fetch_Take_HomeTests: XCTestCase {
    
    // MARK: RecipeService Tests

    func testFetchRecipeSuccess() async throws {
        let service = RecipeService()
        let recipes = try await service.fetchRecipes(from: .recipes)
        
        XCTAssertFalse(recipes.isEmpty, "Recipes should not be empty")
        
        // Test First recipe has required fields
        let firstRecipe = recipes.first!
        XCTAssertFalse(firstRecipe.name.isEmpty, "Recipe name should not be empty")
        XCTAssertFalse(firstRecipe.cuisine.isEmpty, "Recipe name should not be empty")
        XCTAssertFalse(firstRecipe.uuid.isEmpty, "Recipe UUID should not be empty")
    }
    
    func testFetchEmptyRecipes() async throws {
        let service = RecipeService()
        let recipes = try await service.fetchRecipes(from: .empty)
        
        XCTAssertTrue(recipes.isEmpty, "Empty endpoint should return empty array")
    }
    
    func testFetchMalforemdRecipes() async {
        let service = RecipeService()
        
        do {
            _ = try await service.fetchRecipes(from: .malformed)
            XCTFail("Malformed endpoint should throw an error")
        } catch {
            // Expected to throw error
            XCTAssertTrue(true, "Malformed data correctly throws error")
        }
    }
    
    // MARK: ImageCache Tests
    
    func testImageCacheSaveAndLoad() {
        let cache = ImageCache.shared
        let testURL = "https://test.com/image.jpg"
        
        // Create test image data
        let testImage = UIImage(systemName: "star.fill")!
        let testData = testImage.jpegData(compressionQuality: 1.0)!
        
        // Save to cache
        cache.saveImage(testData, for: testURL)
        
        // Load from cache
        let cachedImage = cache.loadImage(for: testURL)
        
        XCTAssertNotNil(cachedImage, "Cached image should not be nil")
        XCTAssertTrue(cache.imageExists(for: testURL), "Image should exist in cache")
    }
    
    func testImageCacheNonExistentImage() {
        let cache = ImageCache.shared
        let fakeURL = "https://fake.com/nonexistent.jpg"
        
        let cachedImage = cache.loadImage(for: fakeURL)
        
        XCTAssertNil(cachedImage, "Non-existent image should return nil")
        XCTAssertFalse(cache.imageExists(for: fakeURL), "Non-existent image should not exist")
    }
    
    // MARK: Recipe Model Tests
    
    func testRecipeDecoding() throws {
        let jsonData = """
            {
                "uuid": "test-123",
                "name": "Test Recipe",
                "cuisine": "Test Cuisine",
                "photo_url_large": "https://test.com/large.jpg",
                "photo_url_small": "https://test.com/small.jpg",
                "source_url": "https://test.com/recipe",
                "youtube_url": "https://youtube.com/watch?v=test"
            }
            """.data(using: .utf8)!
        
        let recipe = try JSONDecoder().decode(Recipe.self, from: jsonData)
        
        XCTAssertEqual(recipe.uuid, "test-123")
        XCTAssertEqual(recipe.name, "Test Recipe")
        XCTAssertEqual(recipe.cuisine, "Test Cuisine")
        XCTAssertEqual(recipe.id, "test-123")
    }

}
