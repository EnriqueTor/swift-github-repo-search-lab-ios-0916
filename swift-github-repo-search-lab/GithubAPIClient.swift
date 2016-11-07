//
//  GithubAPIClient.swift
//  swift-github-repo-search-lab
//
//  Created by Enrique Torrendell on 11/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire

class GithubAPIClient {
    
    //alamafire
    
    
    
    class func getRepositoriesWithCompletion(_ completion: @escaping ([Any]) -> ()) {
        
        let url = "\(Github.githubURL)/repositories?client_id=\(Github.clientID)&client_secret=\(Github.clientSecret)"
        
        Alamofire.request(url).responseJSON { (response) in
            
            if let JSON = response.result.value {
                
                completion(JSON as! Array)
            }
        }
    }
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: @escaping (Bool) -> (Void)) {
        
        let url = "\(Github.githubURL)/user/starred/\(fullName)?access_token=\(Github.personalToken)"
        
        Alamofire.request(url).responseJSON { (response) in
            
            if response.response?.statusCode == 204 {
                completion(true)
            }
                
            else if response.response?.statusCode == 404 {
                completion(false)
            }
        }
    }
    
    class func starRepository(named: String, completion: @escaping ()-> ()) {
        
        let url = "\(Github.githubURL)/user/starred/\(named)?access_token=\(Github.personalToken)"
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "PUT"
        
        Alamofire.request(request).responseJSON { (response) in
            
            if response.response?.statusCode == 204 {
                OperationQueue.main.addOperation {
                    completion()
                }
            }
            else if response.response?.statusCode == 404 {
                OperationQueue.main.addOperation {
                    completion()
                }
            }
        }
    }
    
    class func unstarRepository(named: String, completion: @escaping ()-> ()) {
        
        let url = "\(Github.githubURL)/user/starred/\(named)?access_token=\(Github.personalToken)"
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "DELETE"
        
        Alamofire.request(request).responseJSON { (response) in
            
            if response.response?.statusCode == 204 {
                OperationQueue.main.addOperation {
                    completion()
                }
            }
            else if response.response?.statusCode == 404 {
                OperationQueue.main.addOperation {
                    completion()
                }
            }
        }
    }
    
    class func searchAPI(word: String, completion: @escaping ([String:Any])-> ()) {
        
        let url = "\(Github.githubURL)/search/repositories?q=\(word)&access_token=\(Github.personalToken)"
        
        Alamofire.request(url).responseJSON { (response) in
            
            if let JSON = response.result.value {
                
                let responseJSON = JSON as! [String:Any]
                
                completion(responseJSON)
            }
        }
    }
}
