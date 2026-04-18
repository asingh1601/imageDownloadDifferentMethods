//
//  ViewController.swift
//  UrlsessionAsyncAwait
//
//  Created by Aditya Machhaiya on 18/04/26.
//

import UIKit

enum ImageError: Error {
    case invalidURL
    case networkError
    case decodingFailed
    case notFound
}

class ViewController: UIViewController {
    
    private lazy var imageViewForClosure : UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imageViewForAsyncAwait : UIImageView = {
        let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageForClosure()
        setUpImageForAsyncAwait()
        callImageApi()
        callImageApiAsyncAwait()
        // Do any additional setup after loading the view.
        
       
           
        
    }
    
    private func setUpImageForClosure() {
        view.addSubview(imageViewForClosure)
        
        NSLayoutConstraint.activate([
            imageViewForClosure.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            imageViewForClosure.heightAnchor.constraint(equalToConstant: 120),
            imageViewForClosure.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            imageViewForClosure.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
    
    private func setUpImageForAsyncAwait() {
        view.addSubview(imageViewForAsyncAwait)
        
        NSLayoutConstraint.activate([
            imageViewForAsyncAwait.topAnchor.constraint(equalTo: imageViewForClosure.safeAreaLayoutGuide.bottomAnchor, constant: 24),
            imageViewForAsyncAwait.heightAnchor.constraint(equalToConstant: 120),
            imageViewForAsyncAwait.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            imageViewForAsyncAwait.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
    
    private func callImageApi() {
        ImageDownloadManager.shared.fetchImage("https://picsum.photos/200") { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                self.imageViewForClosure.image = image
                
            case .failure(_):
                self.imageViewForClosure.image = UIImage(named: "placeholder")
            }
        }
    }
    
    private func callImageApiAsyncAwait() {
        
        Task {
            
            do {
                let image = try await ImageDownloadManagerAsyncAwait.shared.getImage(from: "https://picsum.photos/200")
                imageViewForAsyncAwait.image = image
            } catch {
                print(error)
            }
            
        }
    }
    
    


}




