//
//  WalkthroughViewController.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/20/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController{
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var bottomBlurView: UIView!
    @IBOutlet var doneButton: UIButton!
    fileprivate var selectedSubreddits = [String](){
        didSet{
            // If 3 more subs selectd, we enable the done button
//            print("Count is now: \(selectedSubreddits.count)")
            doneButtonInteraction(count: selectedSubreddits.count)
        }
    }
    @IBAction func doneButtonPressed(_ sender: UIButton){
        
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "navigationViewController") as! UINavigationController
        
        Subreddits.user_subreddits.append(contentsOf: selectedSubreddits)
        let recommendedSubs = Subreddits.default_subreddits.filter{
            !Subreddits.user_subreddits.contains($0)
        }
        Subreddits.recommended_subreddits.append(contentsOf: recommendedSubs)
        let userDefaults = UserDefaults.standard
        userDefaults.set(Subreddits.user_subreddits, forKey: Constants.UserSubredditsDefaults)
        userDefaults.set(Subreddits.recommended_subreddits, forKey: Constants.RecommendedSubredditsDefaults)
        present(navigationController, animated: true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CollectionView
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let bottomBlurViewSize = bottomBlurView.frame.size
        let footerSize = CGSize(width: bottomBlurViewSize.width, height: bottomBlurViewSize.height + 10.0)
        flowLayout.footerReferenceSize = footerSize
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //doneButton
        doneButtonInteraction(count: selectedSubreddits.count)
        doneButton.layer.cornerRadius = 10.0
    }
    
    func doneButtonInteraction(count: Int){
        doneButton.isEnabled = count >= 3 ? true : false
        doneButton.isUserInteractionEnabled = count >= 3 ? true : false
        doneButton.backgroundColor = count >= 3 ? UIColor.blue : UIColor.gray
        
    }
}

extension WalkthroughViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Subreddits.default_subreddits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubredditCell", for: indexPath) as! SubredditCollectionViewCell
        let subredditName = Subreddits.default_subreddits[indexPath.row]
        
        cell.subredditName = subredditName
        return cell
    }
}

extension WalkthroughViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let subredditName = Subreddits.default_subreddits[index]
        let cell = collectionView.cellForItem(at: indexPath) as! SubredditCollectionViewCell
        
        if selectedSubreddits.contains(subredditName){
            cell.setCellSelected(false)
            for (i, s) in selectedSubreddits.enumerated(){
                if s == subredditName{
                    selectedSubreddits.remove(at: i)
                }
            }
        }
        else{
            cell.setCellSelected(true)
            selectedSubreddits.append(subredditName)
            print("Sub added: \(subredditName)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let subName = (cell as! SubredditCollectionViewCell).subredditName{
            if selectedSubreddits.contains(subName){
                (cell as! SubredditCollectionViewCell).setCellSelected(true)
            }
        }
    }
    
    
    
}


