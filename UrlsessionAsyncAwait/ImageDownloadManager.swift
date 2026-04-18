//
//  ImageDownloadManager.swift
//  UrlsessionAsyncAwait
//
//  Created by Aditya Machhaiya on 18/04/26.
//
import UIKit


final class ImageDownloadManager {
    
    static let shared = ImageDownloadManager()
    let cacheMemory = NSCache<NSString, UIImage>()
    private init() {}
    
    func fetchImage(_ url: String,
                    completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        // 1. Validate URL
        
        if let cacheImage = cacheMemory.object(forKey: NSString(string: url)) {
            completion(.success(cacheImage))
            return
        }
        guard let imageURL = URL(string: url) else {
            completion(.failure(ImageError.invalidURL))
            return
        }
        
        // 2. Network call
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            
            // 3. Handle error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // 4. Validate data
            guard let data = data else {
                completion(.failure(ImageError.notFound))
                return
            }
            
            // 5. Convert to UIImage
            guard let image = UIImage(data: data) else {
                completion(.failure(ImageError.decodingFailed))
                return
            }
            
            self.cacheMemory.setObject(image, forKey: NSString(string: url))
            
            // 6. Success
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        
        task.resume()
    }
}
