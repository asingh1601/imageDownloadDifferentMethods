//
//  ImageDownloader.swift
//  UrlsessionAsyncAwait
//
//  Created by Aditya Machhaiya on 19/04/26.
//
import UIKit

protocol ImageDownloader {
    func getImage(from url: String) async throws -> UIImage
}
