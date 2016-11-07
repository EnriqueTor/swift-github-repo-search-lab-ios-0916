//
//  ReposDataStore.swift
//  swift-github-repo-search-lab
//
//  Created by Enrique Torrendell on 11/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    //getRepo
    func getRepositoriesFromAPI(_ completion: @escaping () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    
    //toggleStar
    func toggleStarStatus(for repo:GithubRepository, completion: @escaping (Bool) -> ()) {
        
        GithubAPIClient.checkIfRepositoryIsStarred(fullName: repo.fullName) { (isStarred) in
            
            switch isStarred {
                
            case true:
                GithubAPIClient.unstarRepository(named: repo.fullName, completion: {
                    completion(true)
                })
                
            case false:
                GithubAPIClient.starRepository(named:repo.fullName, completion: {
                    completion(false)
                })
                
            }
        }
    }
    
    func searchRepos(item: String, completion: @escaping () -> ()) {
        
        GithubAPIClient.searchAPI(word: item) { (repos) in
            
            self.repositories = []
            
            if let repos = repos["items"] as? [[String:Any]] {
                
                for repo in repos {
                    
                    self.repositories.append(GithubRepository(dictionary: repo))
                }
            }

            completion()
        }
    }
}


