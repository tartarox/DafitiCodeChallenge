//
//  MovieManager.swift
//  DafitiCodeChallenge
//
//  Created by MacBook on 21/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

//refatorar

class MovieManager: NSObject {
    
    //________________________________________________________________________
    //MARK: Network Requests
    //Get movies
    class func getMovies(page:Int, completionHandler: (NSArray) -> ()) {
        
        let movieArray:NSMutableArray = []
        
        RequestManager.movieListRequest(page) { (jsonArray) in
            
            for jsonObject in jsonArray {
                
                let movieObject = MovieObject()

                movieObject.title = jsonObject["title"].string!
                movieObject.runtime = jsonObject["runtime"].int!
                movieObject.overview = jsonObject["overview"].string!
                movieObject.year = jsonObject["year"].int!
                movieObject.genres = jsonObject["genres"].arrayObject!
                movieObject.rating = jsonObject["rating"].float!
                movieObject.released = jsonObject["released"].string!
                movieObject.tagline = jsonObject["tagline"].string!

                movieObject.banner = jsonObject["images"]["banner"]["full"] == nil ? "" : jsonObject["images"]["banner"]["full"].string!
                movieObject.poster = jsonObject["images"]["poster"]["full"] == nil ? "" : jsonObject["images"]["poster"]["full"].string!
                movieObject.clearart = jsonObject["images"]["clearart"]["full"] == nil ? "" : jsonObject["images"]["clearart"]["full"].string!
                movieObject.fanart = jsonObject["images"]["fanart"]["full"] == nil ? "" : jsonObject["images"]["fanart"]["full"].string!
                movieObject.thumb = jsonObject["images"]["thumb"]["full"] == nil ? "" : jsonObject["images"]["thumb"]["full"].string!
                movieObject.logo = jsonObject["images"]["logo"]["full"] == nil ? "" : jsonObject["images"]["logo"]["full"].string!
                
                movieArray.addObject(movieObject)
            }
            
            completionHandler(movieArray as NSArray)
        }
    }
    
    //Search Movies
    class func searchMovies(searchString:String, completionHandler: (NSArray) -> ()) {
        
        let movieArray:NSMutableArray = []
        
        RequestManager.searchMovieRequest(searchString) { (jsonArray) in
            
            for jsonObject in jsonArray {
                
                let movieObject = MovieObject()
                
                movieObject.title = jsonObject["title"].string!
                movieObject.runtime = jsonObject["runtime"].int!
                movieObject.overview = jsonObject["overview"].string!
                movieObject.year = jsonObject["year"].int!
                movieObject.genres = jsonObject["genres"].arrayObject!
                movieObject.rating = jsonObject["rating"].float!
                movieObject.released = jsonObject["released"].string!
                movieObject.tagline = jsonObject["tagline"].string!
                
                movieObject.banner = jsonObject["images"]["banner"]["full"] == nil ? "" : jsonObject["images"]["banner"]["full"].string!
                movieObject.poster = jsonObject["images"]["poster"]["full"] == nil ? "" : jsonObject["images"]["poster"]["full"].string!
                movieObject.clearart = jsonObject["images"]["clearart"]["full"] == nil ? "" : jsonObject["images"]["clearart"]["full"].string!
                movieObject.fanart = jsonObject["images"]["fanart"]["full"] == nil ? "" : jsonObject["images"]["fanart"]["full"].string!
                movieObject.thumb = jsonObject["images"]["thumb"]["full"] == nil ? "" : jsonObject["images"]["thumb"]["full"].string!
                movieObject.logo = jsonObject["images"]["logo"]["full"] == nil ? "" : jsonObject["images"]["logo"]["full"].string!
                
                movieArray.addObject(movieObject)
            }
            
            completionHandler(movieArray as NSArray)
        }
    }
    
    //_____________________________________________________________________
    //MARK: Database Requests
    //Favorite movie and save to Realm
    class func saveMovieToFavorites(movieObject:MovieObject) {
        
        let realmManager = RealmDBManager()
        
        let realmMovieObject = RealmMovieObject()
        realmMovieObject.title = movieObject.title
        realmMovieObject.runtime = movieObject.runtime
        realmMovieObject.overview = movieObject.overview
        realmMovieObject.year = movieObject.year
        realmMovieObject.rating = movieObject.rating
        realmMovieObject.released = movieObject.released
        realmMovieObject.tagline = movieObject.tagline
        
        realmMovieObject.banner = movieObject.banner
        realmMovieObject.poster = movieObject.poster
        realmMovieObject.clearart = movieObject.clearart
        realmMovieObject.fanart = movieObject.fanart
        realmMovieObject.thumb = movieObject.thumb
        realmMovieObject.logo = movieObject.logo
        
        let realmGenreArray = List<RealmGenresObject>()
        for genreString in movieObject.genres {
            
            let realmGenreObject = RealmGenresObject()
            realmGenreObject.genre = genreString as! String
            realmGenreArray.append(realmGenreObject)
            
        }
        
        realmMovieObject.genres = realmGenreArray
        realmManager.saveRealmObject(realmMovieObject)
        
    }
    
    //Convert all favorite realm object in movie object
    class func getFavoriteMoviesFromRealm() -> NSArray {
        
        let realmManager = RealmDBManager()
        let realmMoviesArray = realmManager.getRealmFavoriteMoviesArray()
        
        let movieArray:NSMutableArray = []
        for realmMovieObject in realmMoviesArray {
            
            let movieObject = MovieObject()
            
            movieObject.title = realmMovieObject.title
            movieObject.runtime = realmMovieObject.runtime
            movieObject.overview = realmMovieObject.overview
            movieObject.year = realmMovieObject.year
            movieObject.rating = realmMovieObject.rating
            movieObject.released = realmMovieObject.released
            movieObject.tagline = realmMovieObject.tagline
            
            movieObject.banner = realmMovieObject.banner
            movieObject.poster = realmMovieObject.poster
            movieObject.clearart = realmMovieObject.clearart
            movieObject.fanart = realmMovieObject.fanart
            movieObject.thumb = realmMovieObject.thumb
            movieObject.logo = realmMovieObject.logo
            
            let genreArray: NSMutableArray = []
            for genreObject in realmMovieObject.genres {
        
                genreArray.addObject(genreObject.genre)
            }
            movieObject.genres = genreArray
            movieArray.addObject(movieObject)
        }
        
        return movieArray
    }
    
    //Check if the current film already favorited
    class func checkIfMovieAlreadyFavoritedFromRealm(movieName:String) -> Bool {
        let realmManager = RealmDBManager()
        let realmResponse = realmManager.getFavoriteMovie(movieName)
        
        if realmResponse.isEmpty{
            
            return false
            
        }
        
        return true
        
    }
    
    //Remove movie from favorite list
    class func removeFavoriteMovieFromRealm(movieName:String){
        let realmManager = RealmDBManager()
        let realmResponse = realmManager.getFavoriteMovie(movieName)
        
        if !realmResponse.isEmpty{
            
            realmManager.deleteRealmObject(realmResponse[0])
            
        }
    }
}
