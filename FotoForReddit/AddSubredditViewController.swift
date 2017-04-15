//
//  AddSubredditViewController.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 4/13/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit

class AddSubredditViewController: UIViewController{
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var subSearchInfoLabel: UILabel!
//    @IBOutlet var subCheckingView: UIView!
    @IBOutlet var subCheckingViewConstraint: NSLayoutConstraint!
    var recommendedSubs = Subreddits.recommended_subreddits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddSubredditViewController.doneClicked(_:)))
        navigationItem.title = "Add Subreddit"
        tableView.dataSource = self
        
        toggleSubCheckingView(hide: true)
        
    }


    func toggleSubCheckingView(hide: Bool = false){
        if hide{
            subCheckingViewConstraint.constant = 0.0
            spinner.stopAnimating()
            UIView.animate(withDuration: 0.5){
                self.subSearchInfoLabel.alpha = 0.0
                self.view.layoutIfNeeded()
                }
            
            }
        else{
            subCheckingViewConstraint.constant = 80.0
            spinner.startAnimating()
            UIView.animate(withDuration: 0.5){
                self.subSearchInfoLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            
        }
    }

    func doneClicked(_ sender: UIBarButtonItem){
        parent?.dismiss(animated: true, completion: nil)
    }
}

extension AddSubredditViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedSubs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedSubredditsCell", for: indexPath)
        cell.textLabel?.text = recommendedSubs[indexPath.row]
        let cellAccessoryButton = UIButton(frame: CGRect(x: cell.frame.width - 30, y: cell.frame.height-30, width: 20, height: 20))
        cellAccessoryButton.setImage(#imageLiteral(resourceName: "add_green"), for: .normal)
        cell.accessoryView = cellAccessoryButton
        return cell
    }
}
