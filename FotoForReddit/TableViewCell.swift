//
//  TableViewCell.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/26/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell{
    @IBOutlet var collectionView: UICollectionView!
//    @IBOutlet var collectionView: CustomCollectionViewMain!
    var collectionViewOffset: CGFloat{
        get{
            return collectionView.contentOffset.x
        }
        set{
            collectionView.contentOffset.x = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.reloadData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
    }
}
