//
//  DetailViewController.swift
//  DafitiCodeChallenge
//
//  Created by MacBook on 21/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit
import Haneke
import Social

class DetailViewController: UIViewController {
    
    //____________________________________________________________________
    //MARK: Interface
    var movieObject = MovieObject()
    var movieImages:NSMutableArray = []
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    
    //Constraints
    
    @IBOutlet weak var leftTagLineLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftGenresLabelConstraint: NSLayoutConstraint!
    
    //____________________________________________________________________
    //MARK: Class
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Detect Orientation
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(deviceDidRotate), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        self.setupLabels()
        self.loadImages()

    }
    
    override func viewDidAppear(animated: Bool) {
         super.viewDidAppear(animated)
        
        self.startAnimation()
    }
    
    //Load all strings on labels
    func setupLabels() {
        
        self.renderMainImage()
        
        self.titleLabel.text = String(format: "%@ (%@)", self.movieObject.title, String(self.movieObject.year))
        self.overviewTextView.text = self.movieObject.overview
        self.tagLineLabel.text = self.movieObject.tagline
        self.genresLabel.text = self.movieObject.genres.formatGenres()
        
        self.runtimeLabel.text = String(format: "%i min", self.movieObject.runtime)
        self.ratingLabel.text = String(format: "%.1f / 10.0", self.movieObject.rating)
        self.releaseLabel.text = self.movieObject.released.formatDateString()
        
        //Check if the current movie already favorited
        let alreadyFavorited = MovieManager.checkIfMovieAlreadyFavoritedFromRealm(movieObject.title)
        self.favoriteButton.selected = alreadyFavorited

    }
    
    //Load All available images
    func loadImages() {
        
        if self.movieObject.thumb != "" { self.movieImages.addObject(self.movieObject.thumb) }
        if self.movieObject.poster != "" { self.movieImages.addObject(self.movieObject.poster) }
        if self.movieObject.fanart != "" { self.movieImages.addObject(self.movieObject.fanart) }
        if self.movieObject.logo != "" { self.movieImages.addObject(self.movieObject.logo) }
        if self.movieObject.banner != "" { self.movieImages.addObject(self.movieObject.banner) }
        if self.movieObject.clearart != "" { self.movieImages.addObject(self.movieObject.clearart) }

    }
    
    //Start animation on view elements
    func startAnimation() {
        
        //Setup constraints
        self.leftTagLineLabelConstraint.constant = 16
        self.leftGenresLabelConstraint.constant = 8
        
        //Start animations
        UIView.animateWithDuration(0.6) {
            
            self.tagLineLabel.alpha = 1
            self.genresLabel.alpha = 1
            
            self.view.layoutIfNeeded()
        }
    }
    
    func deviceDidRotate() {
        
        self.renderMainImage()
    }
    
    func renderMainImage() {
        
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            self.mainImageView.hnk_setImageFromURL(NSURL.init(string: self.movieObject.thumb)!)
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            self.mainImageView.hnk_setImageFromURL(NSURL.init(string: self.movieObject.poster)!)
        }
    }
    
    //____________________________________________________________________
    //MARK: Actions
    @IBAction func backAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //Share current movie with friends on facebook
    @IBAction func facebookShareAction(sender: AnyObject) {
        
        let fbShare = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        fbShare.setInitialText(self.movieObject.tagline)
        fbShare.addImage(self.mainImageView.image)
        
        self.presentViewController(fbShare, animated: true, completion: nil)
    }
    
    //Share current movie with friends on twitter
    @IBAction func twitterShareAction(sender: AnyObject) {
        
        let twShare = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twShare.setInitialText(self.movieObject.tagline)
        twShare.addImage(self.mainImageView.image)
        
        self.presentViewController(twShare, animated: true, completion: nil)
    }
    
    //Save or remove a current movie on favorite list
    @IBAction func favoriteAction(sender: UIButton) {
        
        sender.selected = !sender.selected
        sender.popAnimation()
        
        //Movie have been favorited
        if sender.selected {
            
            MovieManager.saveMovieToFavorites(self.movieObject)
            
        //Movie have removed from favorites
        } else {
            
            MovieManager.removeFavoriteMovieFromRealm(self.movieObject.title)
        }
    }
    
    //____________________________________________________________________
    //MARK: UICollectionView Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieImages.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let movieUrl = self.movieImages[indexPath.row] as! String
        self.mainImageView.hnk_setImageFromURL(NSURL.init(string: movieUrl)!)

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let movieUrl = self.movieImages[indexPath.row] as! String
        
        let cell = self.mainCollectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! DetailImageCollectionCell
        
        cell.mainImageView.image = UIImage.init(named: "Image_Background")
        
        //Do a image cache
        cell.mainImageView.hnk_setImageFromURL(NSURL(string: movieUrl)!, placeholder: nil, format: nil, failure: { (error) in
            
            }, success: { (image) in
                
                //Did success on load and cache image
                cell.mainImageView.image = image
                
                //Start Animation
                dispatch_async(dispatch_get_main_queue()) {
                    UIView.animateWithDuration(0.6, animations: {
                        
                        cell.mainImageView.alpha = 1
                        
                    })
                }
        })
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(100, 100)
    }
    
    //____________________________________________________________________
    //MARK: System
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}