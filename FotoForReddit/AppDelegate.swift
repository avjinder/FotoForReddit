//
//  AppDelegate.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/20/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let userDefaults = UserDefaults.standard
        
        UserDefaults.resetStandardUserDefaults()
        
        if let user_subs = userDefaults.array(forKey: Constants.UserSubredditsDefaults), let valid_subs = user_subs as? [String]{
            Subreddits.user_subreddits = valid_subs
        }
        else{
            let walkthroughVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.WalkthroughViewControllerID)
            window!.rootViewController = walkthroughVC
        }
        
//        if !showWalkthrough{
//            let navigationVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navigationViewController")
//            window!.rootViewController = navigationVC
//        }
//        let walkthroughVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "walkthrough")
//        let navigationVC = window!.rootViewController as! UINavigationController
//        navigationVC.viewControllers[0] = walkthroughVC
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(Subreddits.user_subreddits, forKey: Constants.UserSubredditsDefaults)
    }

}

