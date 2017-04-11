//
//  SubredditSectionCollectionViewCell.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 4/10/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit

class SubredditSectionCollectionViewCell: UICollectionViewCell{
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    func setImage(image: UIImage?){
        if let img = image{
            imageView.image = img
            activityIndicator.stopAnimating()
        }
        else{
            activityIndicator.startAnimating()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
    }
}
