//
//  MainViewController.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/25/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    @IBOutlet var tableView: UITableView!
    var cellOffset = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80.0
        tableView.estimatedRowHeight = 80.0
        
        navigationItem.title = "FOTOR"
        let addSubBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.addSubreddit(_:)))
        let removeSubBarItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(removeSubreddit(_:)))
        navigationItem.leftBarButtonItem = removeSubBarItem
        navigationItem.rightBarButtonItem = addSubBarItem
        
        
        startDownloadingSubreddits()
        
        
    }
    
    func removeSubreddit(_ sender: UIBarButtonItem){
        print("Remove sub")
        
    }
    
    func addSubreddit(_ sender: UIBarButtonItem){
        let addSubVC = storyboard!.instantiateViewController(withIdentifier: "AddSubredditViewController")
        let addSubNavVC = UINavigationController(rootViewController: addSubVC)
        navigationController!.present(addSubNavVC, animated: true, completion: nil)
    }
    
    func startDownloadingSubreddits(forPaginationSubURL url: String? = nil){
        if url != nil{
            print("Paginate")
            SubredditGetter.getSubreddit(subUrl: url!){
                response in
                switch response{
                case let .failure(reason):
                    print("Failed to get paginated data: \(reason)")
                case let .success(subItems, subName):
                    if Subreddits.user_subreddit_items[subName] != nil{
                        Subreddits.user_subreddit_items[subName]! += subItems
                        self.tableView.reloadData()
                    }
                }
            }
        }
        else{
            print("Non paginate")
            for sub in Subreddits.user_subreddits{
                let subUrl = SubredditGetter.makeSubredditURL(sub: sub)
                SubredditGetter.getSubreddit(subUrl: subUrl){
                    response in
                    switch response{
                    case let .failure(reason):
                        print("Failed to get data: \(reason)")
                    case let .success(subItems, forSub):
                        if Subreddits.user_subreddit_items[forSub] == nil{
                            Subreddits.user_subreddit_items[forSub] = [SubredditItem]()
                        }
                        
                        if Subreddits.user_subreddit_items[forSub] != nil{
                            print("Adding to dict: \(subItems.count) for: \(forSub)")
                            Subreddits.user_subreddit_items[forSub]! += subItems
                        }
                        else{
                            print("Not added to dict for \(forSub) with count: \(subItems.count) and dictValue: \(String(describing: Subreddits.user_subreddit_items[forSub]?.count))")
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
}


//MARK:- UITableViewDelegate
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Subreddits.user_subreddits[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 24))
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Subreddits.user_subreddits[section]
        label.textColor = UIColor.white
        view.addSubview(label)
//        label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        
        let chevron = UIButton()
        let image = #imageLiteral(resourceName: "chevron_right").withRenderingMode(.alwaysTemplate)
        chevron.tintColor = UIColor.white
        chevron.setImage(image, for: .normal)
        chevron.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chevron)
        chevron.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        chevron.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        
        chevron.tag = section
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.sectionChevronTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        chevron.addGestureRecognizer(tapGesture)
        
        
        view.backgroundColor = UIColor.green
        return view
        
    }
    
    func sectionChevronTapped(_ sender: UIGestureRecognizer){
        guard let view = sender.view else{
            return 
        }
        let section = view.tag
        let subredditName = Subreddits.user_subreddits[section]
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "SubredditSectionViewController") as! SubredditSectionViewController
//        let subNavVC = UINavigationController(rootViewController: vc)
        vc.subredditName = subredditName
        navigationController!.pushViewController(vc, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! TableViewCell).collectionViewOffset = cellOffset[indexPath.section] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellOffset[indexPath.section] = (cell as! TableViewCell).collectionViewOffset
    }
    
    
}

//MARK:- UITableViewDataSource
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Subreddits.user_subreddit_items.count
//        return Subreddits.user_subreddits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let name = Subreddits.user_subreddits[indexPath.section]
        (cell.collectionView as! CustomCollectionViewMain).subredditName = name
//        cell.tag = indexPath.section
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        return cell
    }
    
}
//MARK:- UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let name = (collectionView as! CustomCollectionViewMain).subredditName!
//        return Subreddits.user_subreddit_items[name]!.count
        guard let items = Subreddits.user_subreddit_items[name] else{
            return 0
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! PhotosCollectionViewCell
        let subName = (collectionView as! CustomCollectionViewMain).subredditName!
//        let subName = Subreddits.user_subreddits[collectionView.tag]
        if let subItems = Subreddits.user_subreddit_items[subName]{
            let item = subItems[indexPath.row]
            let thumbnailUrl = item.thumbnailURL
            if let image = SubredditImageGetter.fetchImage(imageURL: thumbnailUrl){
                cell.setImage(image)
            }
            else{
                SubredditImageGetter.downloadImage(url: thumbnailUrl){
                    result in
                    
                    switch result{
                    case let .failure(reason):
                        print("Failed to get image: \(reason)")
                    case .success:
                        for (index,items) in subItems.enumerated(){
                            if item.id == items.id{
                                let indexPath = IndexPath(row: index, section: 0)
                                print("Reloading just \(indexPath.row)")
                                collectionView.reloadItems(at: [indexPath])
                                break
                            }
                        }
//                        self.tableView.reloadData()
//                        collectionView.reloadData()
                    default:
                        return
                    }
                    
                }
            }
//            for item in subItems{
//                let thumbnailUrl = item.thumbnailURL
//                if let image = SubredditImageGetter.fetchImage(imageURL: thumbnailUrl){
//                    cell.setImage(image)
//                    continue
//                }
//                else{
//                    SubredditImageGetter.downloadImage(url: thumbnailUrl){
//                        result in
//                        switch result{
//                        case let .failure(reason):
//                            print("Failed to get image: \(reason)")
//                        case .success:
//                            collectionView.reloadData()
//                        default:
//                            return
//                        }
//                        
//                    }
//                }
//            }
            
        }
        
        return cell
    }
}

//MARK:- UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = (collectionView as! CustomCollectionViewMain).subredditName!
        guard let itemsArray = Subreddits.user_subreddit_items[name] else{
            return
        }
        let item = itemsArray[indexPath.row]
        let imageDetailVC = storyboard!.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        imageDetailVC.item = item
        
        present(imageDetailVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let subName = (collectionView as! CustomCollectionViewMain).subredditName!
        guard let items = Subreddits.user_subreddit_items[subName] else{
            return
        }
        if indexPath.row == items.count - 1{
            let lastItem = items.last!
            let lastId = lastItem.id
            let url = SubredditGetter.makeSubredditPaginationURL(sub: subName, lastItemId: lastId)
            startDownloadingSubreddits(forPaginationSubURL: url)
        }
    }
    
}
    
