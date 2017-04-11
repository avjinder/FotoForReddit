//
//  Subreddit.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/20/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit

class SubredditItem: NSObject{
    var title: String
    var thumbnailURL: String
    var subredditName: String
    var isSFW: Bool
    var photo: Photo
    var id: String
    
    
    init(title: String, thumbnailURL: String, subName: String, isSFW: Bool, photo: Photo, id: String){
        
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.subredditName = subName.lowercased()
        self.isSFW = isSFW
        self.photo = photo
        self.id = id
    }
    
    override var description: String{
        return "Title: \(self.title), thumbnailURL: \(self.thumbnailURL), subredditName: \(self.subredditName), isSFW:\(self.isSFW), id: \(self.id), photo:\(self.photo)"
    }
    
}
    
