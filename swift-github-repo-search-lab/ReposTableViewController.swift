//
//  ReposTableViewController.swift
//  swift-github-repo-search-lab
//
//  Created by Enrique Torrendell on 11/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesFromAPI {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        ac.addTextField { (text) in
            
            
        }
        
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction!) in
            
            let answer = ac.textFields![0]
            
            let text = answer.text
            
            guard let unwrappedText = text else { return }
            
            self.store.searchRepos(item: unwrappedText, completion: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        self.present(ac, animated: true, completion: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        
        
        
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        
        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let repo = store.repositories[indexPath.row]
        
        store.toggleStarStatus(for: repo) { (isStarred) in
            
            //        ReposDataStore.toggleStarStatus(for: repo) { (isStarred)
            
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            switch isStarred {
                
            case false:
                print("I'm not working")
                let alertStarred = UIAlertController(title: "Starred", message: "You just starred \(repo.fullName)", preferredStyle: .alert)
                alertStarred.addAction(alertAction)
                self.present(alertStarred, animated: true, completion: nil)
                // self.alert.accessibilityLabel = "You just starred \(repo.fullName)"
                
            case true:
                print("I'm not working, REALLY!!!")
                let alertUnstarred = UIAlertController(title: "Unstarred", message: "You just unstarred \(repo.fullName)", preferredStyle: .alert)
                alertUnstarred.addAction(alertAction)
                self.present(alertUnstarred, animated: true, completion: nil)
                // self.alert.accessibilityLabel = "You just unstarred \(repo.fullName)"
            }
            
            
        }
        
    }
    
    
    
    
}
