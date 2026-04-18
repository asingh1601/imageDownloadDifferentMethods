//
//  ImageDownloadManagerAsyncAwait.swift
//  UrlsessionAsyncAwait
//
//  Created by Aditya Machhaiya on 18/04/26.
//
import UIKit

final class ImageDownloadManagerAsyncAwait : ImageDownloader {

    static let shared = ImageDownloadManagerAsyncAwait()
    
    var cacheMemory: NSCache = NSCache<NSString,UIImage>()
    
    private init() {}
    
    func getImage(from imageUrl: String) async throws -> UIImage {
        
        // 1. Check cache
        if let cachedImage = cacheMemory.object(forKey:  NSString(string: imageUrl)) {
            return cachedImage
        }
        
        guard let url = URL(string: imageUrl) else {
            throw URLError(.badURL)
            
        }
        
        // 2. Fetch from network
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // 3. Validate response
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        // 4. Convert to UIImage
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        // 5. Store in cache
        self.cacheMemory.setObject(image, forKey: NSString(string: imageUrl))
        
        return image
    }
}
