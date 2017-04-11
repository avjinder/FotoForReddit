//
//  PhotosCollectionViewCell.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/25/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell{
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    func setImage(_ image: UIImage?){
        if let validImage = image{
            imageView.image = validImage
            activityIndicator.stopAnimating()
        }
        else{
            activityIndicator.startAnimating()
            imageView.image = nil
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setImage(nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImage(nil)
    }
}
