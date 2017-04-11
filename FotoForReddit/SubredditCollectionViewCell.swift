//
//  SubredditCollectionViewCell.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/20/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit

class SubredditCollectionViewCell: UICollectionViewCell{
    //MARK:- IBOutlets
    @IBOutlet var subredditNameLabel: UILabel!
    @IBOutlet var subredditIconLabel: UILabel!
        
    var randomBackgroundColor: UIColor!
    var randomTextColor: UIColor!
    var textIconFont: UIFont!
    var subredditName: String?{
        didSet{
            subredditNameLabel.text = subredditName
            if let subName =  subredditName{
                subredditIconLabel.text = subName[subName.startIndex].description
            }
        }
    }
    
    private func makeBorders(color: CGColor = UIColor.gray.cgColor, width: CGFloat = 1.0){
        self.layer.borderColor = color
        self.layer.borderWidth = width
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeBorders()
        setCellSelected(false)
        
        randomBackgroundColor = UIColor.random()
        backgroundColor = randomBackgroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        makeBorders()
        setCellSelected(false)
    }
    
    func setCellSelected(_ selected: Bool){
        subredditIconLabel.textColor = selected ? UIColor.white : UIColor.black
    }
}

extension UIColor{
    static func random() -> UIColor{
        let red = CGFloat(arc4random_uniform(UInt32(100))) / 100.0
        let blue = CGFloat(arc4random_uniform(UInt32(100))) / 100.0
        let green = CGFloat(arc4random_uniform(UInt32(100))) / 100.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
    }
}
