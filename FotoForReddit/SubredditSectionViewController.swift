//
//  SubredditSectionViewController.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 4/10/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit
import Alamofire

class SubredditSectionViewController: UIViewController{
    @IBOutlet var sectionCollectionView: UICollectionView!
    var subredditName: String!
    var subredditItems: [SubredditItem] = [SubredditItem]()
    var paginationRequest: Alamofire.DataRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let validItems = Subreddits.user_subreddit_items[subredditName]{
            subredditItems = validItems
            sectionCollectionView.reloadData()
        }
        
        
        
        sectionCollectionView.dataSource = self
        sectionCollectionView.delegate = self
        navigationItem.title = subredditName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        paginationRequest?.cancel()
    }
    
    
}

extension SubredditSectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subredditItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! PhotosCollectionViewCell
        let item = subredditItems[indexPath.row]
        if let image = SubredditImageGetter.fetchImage(imageURL: item.thumbnailURL){
            cell.setImage(image)
        }
        else{
            SubredditImageGetter.downloadImage(url: item.thumbnailURL){
                result in
                switch result{
                case let .failure(reason):
                    print("Error fetching image: \(reason)")
                case .success:
                    for (index, subItem) in self.subredditItems.enumerated(){
                        if item.id == subItem.id{
                            let indexPath = IndexPath(row: index, section: 0)
                            self.sectionCollectionView.reloadItems(at: [indexPath])
                            
                        }
                    }
                    
                default:
                    return
                }
            }
        }
        return cell
    }
    
}

extension SubredditSectionViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == subredditItems.count - 1{
            print("Row: \(indexPath.row) and subcount: \(subredditItems.count)")
            let lastItem = subredditItems[indexPath.row]
            let paginatedURL = SubredditGetter.makeSubredditPaginationURL(sub: subredditName, lastItemId: lastItem.id)
            
            if let validRequest = paginationRequest{
                if validRequest.request!.url!.absoluteString == paginatedURL{
                    return
                }
            }
            
            print("Make pagination request for: \(paginatedURL)")
            
            paginationRequest =  SubredditGetter.getSubreddit(subUrl: paginatedURL){
                response in
                switch response{
                case let .failure(reason):
                    print("Failure fetching paginated data for \(self.subredditName): \(reason)")
                case let .success(items, subName):
                    if Subreddits.user_subreddit_items[subName] != nil{
                        Subreddits.user_subreddit_items[subName]! += items
                        self.subredditItems = Subreddits.user_subreddit_items[subName]!
                    }
                    self.sectionCollectionView.reloadData()
                }
            }
            
            
            
            
//            SubredditGetter.nextPageItems(subName: subredditName){
//                response in
//                switch response{
//                case let .failure(reason):
//                    print("Failure fetching paginated data for \(self.subredditName): \(reason)")
//                case let .success(items, subName):
//                    if Subreddits.user_subreddit_items[subName] != nil{
//                        Subreddits.user_subreddit_items[subName]! += items
//                    }
//                    self.sectionCollectionView.reloadData()
//                }
//                
//            }
        }
    }
}
