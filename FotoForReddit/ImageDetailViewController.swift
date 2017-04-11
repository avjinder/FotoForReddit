//
//  ImageDetailViewController.swift
//  FotoForReddit
//
//  Created by Avjinder Singh Sekhon on 3/27/17.
//  Copyright © 2017 Avjinder Singh Sekhon. All rights reserved.
//

import UIKit
import Kingfisher

class ImageDetailViewController: UIViewController{
    var imageView: UIImageView!
    @IBOutlet var closeViewController: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    var item: SubredditItem!
    var blurView: UIVisualEffectView?
    var vibrancyView: UIVisualEffectView?
    var indicator: UIActivityIndicatorView?
    var downloadTask: RetrieveImageDownloadTask?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        downloadTask?.cancel()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photo = item.photo
        let photoUrl = photo.url
        imageView = UIImageView(frame: CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.frame.size
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
        
        let blur = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blur)
        
        let crossImage = UIImageView(image: #imageLiteral(resourceName: "cross"))
        crossImage.frame = CGRect(x: view.frame.size.width - 50, y: 50, width: 30, height: 30)
        crossImage.contentMode = .scaleAspectFit
        blurView.frame = crossImage.frame
        blurView.layer.cornerRadius = 2.0
        crossImage.addSubview(blurView)
        view.addSubview(crossImage)
        
        
        if let mainImage = SubredditImageGetter.fetchImage(imageURL: photoUrl){
            setFullImage(mainImage)
        }
        else{
            downloadTask = SubredditImageGetter.downloadImage(url: photoUrl){
                result in
                switch result{
                case let .failure(reason):
                    print("Failed to get image: \(reason)")
                case .success:
                    OperationQueue.main.addOperation {
                        self.fetchMainImageFromCache(url: photoUrl)
                        print("Success")
                    }
                default:
                    print("default")
                }
            }
        }
        
        let thumbnailUrl = item.thumbnailURL
        if imageView.image == nil{
            if let thumbnail = SubredditImageGetter.fetchImage(imageURL: thumbnailUrl){
                setThumbnailImage(thumbnail)
            }
        }
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(ImageDetailViewController.finishSelf(_:)))
        swipeDownGesture.direction = .down
        swipeDownGesture.numberOfTouchesRequired = 1
        
        view.addGestureRecognizer(swipeDownGesture)
        
    }
    
    func addGesturesToScrollView(){
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(ImageDetailViewController.finishSelf(_:)))
        swipeDownGesture.direction = .down
        swipeDownGesture.numberOfTouchesRequired = 1
        
        scrollView.addGestureRecognizer(swipeDownGesture)
        scrollView.panGestureRecognizer.require(toFail: swipeDownGesture)
        
        let doubleTapScrollView = UITapGestureRecognizer(target: self, action: #selector(ImageDetailViewController.scrollViewDoubleTapped(_:)))
        doubleTapScrollView.numberOfTapsRequired = 2
        
        scrollView.addGestureRecognizer(doubleTapScrollView)
    }
    
    func scrollViewDoubleTapped(_ sender: UIGestureRecognizer){
        
        if scrollView.zoomScale > scrollView.minimumZoomScale{
            scrollView.setZoomScale(1.0, animated: true)
            print("Inside if \(scrollView.zoomScale) \(#line)")
        }
        else{
            let gesture = sender as! UITapGestureRecognizer
            let pointTouched = gesture.location(in: scrollView)
            let diff: CGFloat = 20.0
            let rect = CGRect(x: pointTouched.x - diff, y: pointTouched.y - diff, width: diff * 2, height: diff * 2)
            print(rect, #line)
            scrollView.zoom(to: rect, animated: true)
            scrollView.zoomScale = scrollView.maximumZoomScale
        }
        
    }
    
    func finishSelf(_ sender: UIGestureRecognizer){
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func fetchMainImageFromCache(url: String){
        if let image = SubredditImageGetter.fetchImage(imageURL: url){
            setFullImage(image)
        }
        
    }
    
    fileprivate func setThumbnailImage(_ thumb: UIImage){
        imageView.image = thumb
        
        blurView = UIVisualEffectView(frame: imageView.frame)
        blurView?.translatesAutoresizingMaskIntoConstraints = false
        let blur = UIBlurEffect(style: .light)
        blurView!.effect = blur
        blurView!.isUserInteractionEnabled = true
        view.insertSubview(blurView!, aboveSubview: imageView)
        
        vibrancyView = UIVisualEffectView(frame: blurView!.frame)
        vibrancyView?.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView!.effect = UIVibrancyEffect(blurEffect: blur)
        vibrancyView!.isUserInteractionEnabled = true
        view.insertSubview(vibrancyView!, aboveSubview: blurView!)
        
        
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        indicator!.color = UIColor.black
        indicator!.center = imageView.center
        indicator!.startAnimating()
        
        view.insertSubview(indicator!, aboveSubview: vibrancyView!)
        
    }
    
    fileprivate func setFullImage(_ image: UIImage){
        addGesturesToScrollView()
        imageView.image = image
        guard let blur = blurView, let vib = vibrancyView, let ind = indicator else{
            return
        }
        UIView.animate(withDuration: 2.5, animations: {
            blur.alpha = 0.0
            blur.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            vib.alpha = 0.0
            vib.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            ind.stopAnimating()
            ind.removeFromSuperview()
        }, completion: {
            finished in
            if finished{
                blur.removeFromSuperview()
                vib.removeFromSuperview()
            }
        })
    }
    
}

extension ImageDetailViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
