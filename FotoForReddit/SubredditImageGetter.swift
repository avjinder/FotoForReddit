//
//  SubredditImageGetter.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/26/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit
import Kingfisher

struct SubredditImageGetter{
    enum ImageResult{
        case success
        case failure(String)
        case noInternetConnection
    }
    
    @discardableResult static func downloadImage(url: String, completion: @escaping (ImageResult)->Void) -> RetrieveImageDownloadTask?{
        if let validUrl = URL(string: url){
            print("Downloading for \(validUrl.absoluteString)")
            let task = ImageDownloader.default.downloadImage(with: validUrl, options: nil, progressBlock: nil){
                (image, error, url, data) in
                guard let validImage = image, error == nil else{
                    print("Error is \(String(describing: error))")
                    completion(.failure("Could not download image"))
                    return
                }
            
                ImageCache.default.store(validImage, original: data, forKey: url!.absoluteString, processorIdentifier: "", cacheSerializer: DefaultCacheSerializer.default, toDisk: true, completionHandler:{
                    completion(.success)
                })
//                completion(.success)
            }
            return task
        }
        else{
            completion(.failure("URL not valid"))
        }
        return nil
    }
    
    static func fetchImage(imageURL: String) -> UIImage?{
//        print("Fetching for \(imageURL)")
        return ImageCache.default.retrieveImageInDiskCache(forKey: imageURL, options: nil)
    }
    
    
}
