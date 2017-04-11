//
//  Photo.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/25/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit

class Photo: NSObject{
    var size: CGSize
    var url: String
    
    init(url: String, size: CGSize){
        self.size = size
        self.url = url
    }
    
    override var description: String{
        return "Height: \(self.size.height), width: \(self.size.width), and url: \(self.url)"
    }
    
}
