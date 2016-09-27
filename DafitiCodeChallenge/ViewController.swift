//
//  ViewController.swift
//  DafitiCodeChallenge
//
//  Created by MacBook on 21/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit
import Haneke

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    //____________________________________________________________________
    //MARK: Interface
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchActivity: UIActivityIndicatorView!
    
    
    let cache = Shared.imageCache //Haneke image cache System
    var cellWidth = (UIScreen.mainScreen().bounds.size.width - 20) / 3 //Cell size layout
    var currentPage = 0 //Current page count for requests
    var moviesObjectArray:NSMutableArray = [] //Movie object array to display
    var permitRequest = true //Control if user can do request or not
    var refreshControl = UIRefreshControl() //Reload CollectionView
    var moviesObjectArrayBackup = [] //Backup of last movies array
    
    //____________________________________________________________________
    //MARK: Class
    override func viewDidLoad() {
        super.viewDidLoad()

        //Detect Orientation
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(deviceDidRotate), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        //Create a refresh component
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.addTarget(self, action: #selector(refreshMovies), forControlEvents: .ValueChanged)
        self.mainCollectionView!.addSubview(self.refreshControl)
        
        //Do first Request
        self.startRequest()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Refresh favorites if favorite button is selected
        if favoriteButton.selected {
            
            self.moviesObjectArray = MovieManager.getFavoriteMoviesFromRealm() as! NSMutableArray
            self.mainCollectionView.reloadData()
        }
    }
    
    //Reload contents
    func refreshMovies() {
        
        //Clear Elements first
        self.currentPage = 0
        self.moviesObjectArray = []
        
        //Do request
        self.startRequest()
    }
    
    //Get movie list and add to movie array
    func startRequest() {
        
        if self.permitRequest == false {
            return
        }
        
        self.searchActivity.alpha = 1
        self.permitRequest = false //User cant do new requests
        
        MovieManager.getMovies(self.currentPage) { (moviesArray) in
            
            if moviesArray.count == 0 {
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.searchActivity.alpha = 0
                    ErrorManager.showConnectionError(self)
                }
                return
            }
            
            self.moviesObjectArray.addObjectsFromArray(moviesArray as [AnyObject])
            self.currentPage += 20 //Add more 20 itens on next request
            self.permitRequest = true //User can do request again
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.mainCollectionView.reloadData() //Reload Tableview
                self.refreshControl.endRefreshing() //Dismiss refresh view
                self.searchActivity.alpha = 0 //Hide activity on search left
            }
        }
    }
    
    //Get movie list based on String sended
    func startSearch(searchString: String) {
        
        self.searchActivity.alpha = 1
        MovieManager.searchMovies(searchString) { (moviesArray) in
            
            self.moviesObjectArray = moviesArray as! NSMutableArray
            
            dispatch_async(dispatch_get_main_queue()) {
                self.mainCollectionView.reloadData()
                self.searchActivity.alpha = 0
            }
        }
    }
    
    //Render cells when user rotate device
    func deviceDidRotate() {
        
        self.cellWidth = (UIScreen.mainScreen().bounds.size.width - 20) / 3
        
        guard let flowLayout = self.mainCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.itemSize = CGSize(width: self.cellWidth, height: self.cellWidth)
        flowLayout.invalidateLayout()
        
    }
 
    //____________________________________________________________________
    //MARK: UICollectionView Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesObjectArray.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let movieObject = self.moviesObjectArray[indexPath.row] as! MovieObject
        self.performSegueWithIdentifier("ShowDetailSegue", sender: movieObject)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let movieObject = self.moviesObjectArray[indexPath.row] as! MovieObject
        
        let cell = self.mainCollectionView.dequeueReusableCellWithReuseIdentifier("MainCell", forIndexPath: indexPath) as! MainCollectionViewCell
        
        cell.mainImageView.image = UIImage.init(named: "Image_Background")
        cell.titleLabel.text = movieObject.title
        cell.yearLabel.text = String(movieObject.year)
        
        //Do a image cache
        cell.mainImageView.hnk_setImageFromURL(NSURL(string: movieObject.thumb)!, placeholder: nil, format: nil, failure: { (error) in
            
            cell.activityView.stopAnimating()
            cell.activityView.hidden = true
            
            }, success: { (image) in
                
                //Did success on load and cache image
                cell.activityView.stopAnimating()
                cell.activityView.hidden = true
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
 
        return CGSizeMake(self.cellWidth, self.cellWidth)
    }
    
    //____________________________________________________________________
    //MARK: Actions
    
    @IBAction func favoriteAction(sender: UIButton) {
        
        sender.popAnimation()
        sender.selected = !sender.selected
        
        //Movie Favorite is enable
        if sender.selected {
            
            self.moviesObjectArrayBackup = self.moviesObjectArray
            self.moviesObjectArray = MovieManager.getFavoriteMoviesFromRealm() as! NSMutableArray
            
        //Movie Favorite is disable
        } else {
            
            self.moviesObjectArray = self.moviesObjectArrayBackup as! NSMutableArray
        }

        self.mainCollectionView.reloadData()
    }
    
    //____________________________________________________________________
    //MARK: ScrollView Delegates
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.searchBar.resignFirstResponder()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height - 5)) {
            
            //request for more movies
            self.startRequest()
        }
    }
    
    //____________________________________________________________________
    //MARK: Searchbar Delegates
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        self.performSelector(#selector(ViewController.startSearch(_:)), withObject: searchBar.text, afterDelay: 0.5)

    }
    
    //____________________________________________________________________
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //Receive movie object to display on DetailViewController
        if segue.identifier == "ShowDetailSegue" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.movieObject = sender as! MovieObject
        }
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