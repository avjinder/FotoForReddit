//
//  SubredditGetter.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/20/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum SubredditResponse: Error{
    case success([SubredditItem], String)
    case failure(String)
}

struct SubredditGetter{
    static let BASEURL = "https://www.reddit.com/"
    
    static func makeSubredditURL(sub: String) -> String{
        return "\(BASEURL)r/\(sub).json"
        
    }
    static func makeSubredditPaginationURL(sub: String, lastItemId: String) -> String{
        let count = 25
        let paginatedURL = "\(makeSubredditURL(sub: sub))?after=\(lastItemId)&count=\(count)"
        print("Paginated URL: \(paginatedURL)")
        return paginatedURL
        
    }
    
    @discardableResult static func getSubreddit(subUrl: String, completion: @escaping (SubredditResponse) -> Void) -> Alamofire.DataRequest{
//        print("Url received is \(subUrl)", #line)
        let req = Alamofire.request(subUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["User-Agent": "FotoForReddit"])
        
        req.responseJSON{
            response in
            if let err = response.error{
                print("Found error: \(err)")
                return
            }
            if let data = response.data{
                let swifty = JSON(data: data)
                var allItems = [SubredditItem]()
                if let innerDataArray = swifty["data"]["children"].array{
                    for item in innerDataArray{
                        if let domain = item["data"]["domain"].string, domain.hasPrefix("self"){
                            continue
                        }
                        if let stickied = item["data"]["stickied"].bool, stickied == true{
                            continue
                        }
                        let subredditName = item["data"]["subreddit"].string
                        let isSFW = item["data"]["brand_safe"].bool
                        let title = item["data"]["title"].string
                        let thumbnailURL = item["data"]["thumbnail"].string
                        
                        if thumbnailURL == "nsfw"{
                            continue
                        }
                        
                        let name = item["data"]["name"].string
                        guard let image = item["data"]["preview"]["images"][0]["source"].dictionary else{
                            continue
                        }
                        let width = image["width"]!.int
                        let height = image["height"]!.int
                        let photoURL = image["url"]!.string
                        
                        guard let t = title, let sn = subredditName, let sfw = isSFW, let tu = thumbnailURL, let id = name, let w = width, let h = height, let pu = photoURL else{
                            completion(.failure("Found an error: \(#line)"))
                            return
                        }
                        
                        let photo = Photo(url: pu, size: CGSize(width: w, height: h))
                        
                        let item = SubredditItem(title: t, thumbnailURL: tu, subName: sn, isSFW: sfw, photo: photo, id: id)
//                        print("Sub: \(sn)")
                        allItems.append(item)
                    }
                    
                }
//                completion(.success(allItems, allItems[0].subredditName))
                completion(.success(allItems, allItems.first?.subredditName ?? ""))
                return
            }
            completion(.failure("Testing yo"))
        }
        return req
    }
    
    static func nextPageItems(subName: String, completion: @escaping (SubredditResponse)->Void) -> Alamofire.DataRequest?{
        guard let existingItems = Subreddits.user_subreddit_items[subName], existingItems.count > 0 else{
            completion(.failure("Nothing more to get"))
            return nil
        }
        let lastItem = existingItems.last!
        let lastItemId = lastItem.id
        let nextItemsURL = "\(makeSubredditURL(sub: subName))?after=\(lastItemId)"
        print("nextItemsURL: \(nextItemsURL)")
        return getSubreddit(subUrl: nextItemsURL, completion: completion)
        
        
    }
    
}
