//
//  SubredditImageStore.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/20/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit
import Kingfisher

struct SubredditImageStore{
    func downloadImage(url: String){
        if let validURL = URL(string: url){
            ImageDownloader.default.downloadImage(with: validURL, options: [], progressBlock: nil){
                (image, error, url, data) in
                if error != nil{
                    return
                }
                guard let validImage = image else{
                    return
                }
                ImageCache.default.store(validImage, original: data, forKey: url!.absoluteString, processorIdentifier: "", cacheSerializer: DefaultCacheSerializer.default, toDisk: true, completionHandler: nil)
            }
            
        }
    }
    
    func fetchImage(url: String, completion: @escaping (UIImage) -> Void){
        
        
    }
    
    
}
