//
//  CachedAsyncImage.swift
//  Fetch Take Home
//
//  Created by Austin Burgess on 6/13/25.
//


//
// CachedAsyncImage.swift
// Fetch Take Home
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: String?
    let width: CGFloat
    let height: CGFloat
    
    @State private var image: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipped()
                    .cornerRadius(8)
            } else if isLoading {
                // Loading placeholder
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: width, height: height)
                    .overlay(
                        ProgressView()
                            .scaleEffect(0.8)
                    )
            } else {
                // Error placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: width, height: height)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url = url, !url.isEmpty else {
            isLoading = false
            return
        }
        
        // Use your cache!
        if let loadedImage = await ImageCache.shared.fetchImage(from: url) {
            await MainActor.run {
                self.image = loadedImage
                self.isLoading = false
            }
        } else {
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}
