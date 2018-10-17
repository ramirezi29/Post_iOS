//
//  PostController.swift
//  Post_iOS22
//
//  Created by Ivan Ramirez on 10/15/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation

class PostController: Codable {
    
    // Starting point our URL. We will build off to fetch and post
    static let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    static func fetchPosts(completion: @escaping ([Post]) -> Void) {
        
        enum HttpMethod: String {
            case put = "PUT"
            case post = "POST"
            case patch = "Patch"
            case delete = "Delete"
            case get = "GET"
        }
        
        // 👻 Step 1 - Construct the URL
        // the user is expecting the return. need to give them an empty array in this example, to tell the ViewController to let the User know nothing came back
        guard let url = baseURL else {completion ([]); return }
        
        // NOTE: appendPathComponent mutates
        // url.appendPathComponent()
        let getterEndPoint = url.appendingPathExtension("json")
        // NOTE: - URL up to this point the URL should be the following: https://devmtn-posts.firebaseio.com/posts.json
        print(getterEndPoint)
        
        // 👻 Step 2 - Create the URLRequest, define that we are trying to upload, download.... data?
        var request = URLRequest(url: getterEndPoint)
        //httpMethod is be default GET
        request.httpMethod = "GET"
        // httpBody: this is where we give the data we want to put on the interent
        // httpBody by default is nil
        request.httpBody = nil
        
        // 👻 Step 3 - Data Task + RESUME
        // DATA Task. the person responsale of goign to the interent and getting our data
        // Needs a completion handler so we can know it finished running
        // DataTask person lets the PostController and than so on, know if it was successful or there was an error. That way the user isnt looking at the loading screen/symbol? all without knowing theres an error.
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("\n\n\n\n🚀 There was an error an error retrieving the data from the endpoint in: \(#function);\n\n \(error);\n\n \(error.localizedDescription) 🚀\n\n\n\n")
                completion([])
                return
            }
            
            // Unwrap the data, we have data now
            guard let data = data else {completion ([]); return}
            
            // Need to use decoder in order to turn the JSON Data into useful data
            // Turn into actual Post objects
            // Need to use a DO Try Catch
            //Create an instance of JSonDecoder
            let decoder = JSONDecoder()
            do {
                // decoder needs to know the type
                let postDictionaries = try decoder.decode([String: Post].self, from: data)
                
                // 🍕 Step 1.  create an array to hold the array
                var posts = [Post]()
                // 🍕 Step 2. loop through the dictionary to grab your array
                for (_, value) in postDictionaries {
                    posts.append(value)
                }
                // Now that we have the posts we need to call completion to let the caller know we have all the posts and we are done
                completion(posts)
                //if there was an error, it'll continue with the next chucnk of code
            } catch {
                print("\n\n🚀 There was an error with decoding the data: in the \(#function); \n\n\(error); \n\n\(error.localizedDescription) 🚀\n\n")
                // let the caller know there was an error and they can continue with their work
                completion([])
                return
            }
            }.resume()
    }
    
    // MARK: - Post Function 
    static func addNewPostWith(username: String, text: String, completion: @escaping ([Post]?) -> Void) {
        
        enum HttpMethod: String {
            case put = "PUT"
            case post = "POST"
            case patch = "Patch"
            case delete = "Delete"
        }
        
        let post = Post(username: username, text: text)
        guard let url = baseURL else {
            fatalError("Bad Base URL")
        }
        
        let builtURL = url.appendingPathExtension("json")
        var request = URLRequest(url: builtURL)
        
        do {
            let postData = try JSONEncoder().encode(post)
            request.httpMethod = HttpMethod.post.rawValue
            request.httpBody = postData
        } catch let error {
            print("🚀 There was an error with encoding the Post in:\(#function); \(error); \(error.localizedDescription) 🚀")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("🚀 There was an error with dataTask in:\(#function); \(error); \(error.localizedDescription) 🚀")
                completion([]); return
            }
            
            guard let data = data else { completion ([]); return}
            
            if let objectString = String(data: data, encoding: .utf8) {
                print(objectString)
            } else {
                print("Bad Data")
                completion ([]); return
            }
            
            var posts = [Post]()
            posts.append(post)
            completion(posts)
            }.resume()
    }
}

