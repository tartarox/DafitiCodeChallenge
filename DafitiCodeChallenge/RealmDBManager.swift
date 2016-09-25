//
//  RealmDBManager.swift
//  DafitiCodeChallenge
//
//  Created by Fabio Yudi Takahara on 24/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit
import RealmSwift

class RealmDBManager: NSObject {
    
    let realm = try! Realm()
    
    //Save object to Realm DB
    func saveRealmObject(object: Object) {
        
        try! realm.write {
            realm.add(object)
        }
    }
    
    //Delete object from Realm DB
    func deleteRealmObject(object: Object) {
        
        try! realm.write {
            realm.delete(object)
        }
    }
    
    //Query to get all favorite movies
    func getRealmFavoriteMoviesArray() -> Results<RealmMovieObject> {
        
        return realm.objects(RealmMovieObject.self)
    }
    
    //Query to get all favorite movies
    func getFavoriteMovie(movieName: String) -> Results<RealmMovieObject> {
        
        let queryString = String(format:"title = '%@'", movieName)
        return realm.objects(RealmMovieObject.self).filter(queryString)
    }
}

//_______________________________________________________________
//MARK: Realm Objects

class RealmMovieObject: Object {
    
    dynamic var title = ""
    dynamic var runtime = 0
    dynamic var overview = ""
    dynamic var year = 0
    var genres = List<RealmGenresObject>()
    dynamic var rating: Float = 0.0
    dynamic var released = ""
    dynamic var tagline = ""
    
    dynamic var banner = ""
    dynamic var poster = ""
    dynamic var clearart = ""
    dynamic var fanart = ""
    dynamic var thumb = ""
    dynamic var logo = ""

}

class RealmGenresObject: Object {
    
    dynamic var genre = ""
}

