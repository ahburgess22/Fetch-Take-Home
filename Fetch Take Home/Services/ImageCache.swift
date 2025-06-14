//
//  ImageCache.swift
//  Fetch Take Home
//
//  Created by Austin Burgess on 6/13/25.
//


//
// ImageCache.swift
// Fetch Take Home
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    private init() {
        createCacheDirectory()
    }
    
    // MARK: - Cache Directory Setup
    
    // Get the app's cache directory and create our subfolder
    private var cacheDirectory: URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("ImageCache")
    }
    
    // Create the cache folder if it doesn't exist
    private func createCacheDirectory() {
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    // MARK: - Cache Key Generation
    
    // Convert URL to safe filename (replace problematic characters)
    private func cacheKey(for url: String) -> String {
        return url.replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")
            .replacingOccurrences(of: "?", with: "_")
    }
    
    // Get full file path for cached image
    private func cacheFilePath(for url: String) -> URL {
        let fileName = cacheKey(for: url) + ".jpg"
        return cacheDirectory.appendingPathComponent(fileName)
    }
    
    // MARK: - Core Cache Methods
    
    // Save image data to disk
    func saveImage(_ data: Data, for url: String) {
        let filePath = cacheFilePath(for: url)
        try? data.write(to: filePath)
    }
    
    // Load image from disk cache
    func loadImage(for url: String) -> UIImage? {
        let filePath = cacheFilePath(for: url)
        guard let data = try? Data(contentsOf: filePath) else { return nil }
        return UIImage(data: data)
    }
    
    // Check if image exists in cache without loading it
    func imageExists(for url: String) -> Bool {
        let filePath = cacheFilePath(for: url)
        return FileManager.default.fileExists(atPath: filePath.path)
    }
    
    // MARK: - Network + Cache Combined Method
    
    // The main method your UI will call - checks cache first, then downloads
    func fetchImage(from urlString: String) async -> UIImage? {
        // 1. Check cache first
        if let cachedImage = loadImage(for: urlString) {
            return cachedImage
        }
        
        // 2. Not in cache, download from network
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // 3. Save to cache for next time
            saveImage(data, for: urlString)
            
            // 4. Return the image
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}