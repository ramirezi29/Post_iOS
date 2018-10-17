//
//  PostsListTableViewController.swift
//  Post_iOS22
//
//  Created by Ivan Ramirez on 10/15/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit
//import UserNotifications

class PostsListTableViewController: UITableViewController {
    
    
    @IBOutlet weak var addPostButton: UIBarButtonItem!
    
    
    let posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    // MARK: - Funcs
    func fetchPosts() {
        
        // PostController.fetchPosts(completion: <#T##([Post]) -> Void#>)
        PostController.fetchPosts { ([Post]) in
            if (self.posts) != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.title = "There was an Error with your request: Please Try Again 🙅🏿‍♂️"
                    print("Theres an error in the fetch Post ")
                }
            }
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        prsentNewPostAlert()
    }
    
    
    @IBAction func userRefreshed(_ sender: UIRefreshControl) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostController.fetchPosts{_ in
            self.reloadTableView()
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
        }
    }
    
}

// MARK: - Table view data source and Segue
extension PostsListTableViewController  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username), \(post.timestamp)"
        return cell
    }
    
}

// MARK: - Alert
extension PostsListTableViewController {
    func prsentNewPostAlert() {
        let alertController = UIAlertController(title: "Post iOS22", message: "The Best Post App on the App Store", preferredStyle: .alert)
        
        alertController.addTextField { (userName) in
            
            userName.placeholder = "Enter User's Name"
            userName.font = UIFont(name: "HelveticaNeue-light", size: 15)
        }
        
        alertController.addTextField { (messageText) in
            messageText.placeholder = "Enter Post"
            messageText.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        }
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            // the text
            guard let usersNameTextField = alertController.textFields?.first?.text,
                let usersMessageText = alertController.textFields?[1].text else {return}
            PostController.addNewPostWith(username: usersNameTextField, text: usersMessageText, completion: { (_) in
                if (self.posts) != nil  {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
            let dismissAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alertController.addAction(dismissAction)
            alertController.addAction(postAction)
            self.present(alertController, animated: true)
        }
    }


