//
//  RequestManager.swift
//  DafitiCodeChallenge
//
//  Created by MacBook on 21/09/16.
//  Copyright © 2016 Fabio Yudi Takahara. All rights reserved.
//

import UIKit
import SwiftyJSON

class RequestManager: NSObject {

    class func movieListRequest(currentPage: Int,completionHandler: ([JSON]) -> ()){
        
        let urlPath = String(format: "https://api.trakt.tv/movies/popular?extended=full,images&page=%i&limit=30", currentPage)
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.setRequestParameters()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if data == nil {
                
                completionHandler([])
                
            } else {
                
                let jsonObj = JSON(data: data!)
                if jsonObj != JSON.null {
                    
                    //Success on request
                    completionHandler(jsonObj.array!)
                    
                } else {
                    //Did error on request
                    completionHandler([])
                }
            }
        })
        task.resume()
    }
    
    class func searchMovieRequest(searchString: String,completionHandler: ([JSON]) -> ()){
        
        let urlPath = String(format: "https://api.trakt.tv/movies/popular?query=%@&extended=full,images", searchString)
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.setRequestParameters()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if data == nil {
                
                completionHandler([])
                
            } else {
                
                let jsonObj = JSON(data: data!)
                if jsonObj != JSON.null {
                    
                    //Success on request
                    completionHandler(jsonObj.array!)
                    
                } else {
                    //Did error on request
                    completionHandler([])
                }
            }
        })
        task.resume()
    }
}

extension NSMutableURLRequest {
    
    //Set parametes of NSMutableURLRequest
    func setRequestParameters(){
        
        self.HTTPMethod = "GET"
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.addValue("a0c9e1842e5b4bd2fa07bd814a13659b5e6561b9d556144a6ddb73c838844a6b", forHTTPHeaderField: "trakt-api-key") //API Key
        self.addValue("2", forHTTPHeaderField: "trakt-api-version")
    }
}
