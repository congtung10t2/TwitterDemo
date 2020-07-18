//
//  HomeViewModel.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//
import FirebaseAuth

protocol HomeViewModelProtocol: class {
  var posts: [String: Post] { get set }
  var loadedData: (() -> ())? { get set }
  var isSignedIn: Bool { get }
  func fetchAllPosts()
  func writePost(post: Post, completion: @escaping (String?, Error?) -> Void)
  func removePost(id: String, completion: @escaping (Error?) -> Void)
  func getPostByDate() -> [(String, Post)]
  func signOut()
  var onError: ((Error) -> Void)? { get set }
}

class HomeViewModel : HomeViewModelProtocol {
  
  var loadedData: (() -> ())?
  var onError: ((Error) -> Void)?
  var posts: [String: Post] = [:] {
    didSet {
      loadedData?()
    }
  }
  var isSignedIn: Bool {
    return UserManager.shared.isSignedIn()
  }
  
  func fetchAllPosts() {
    DataManager.shared.fetchAll() { (posts, error) in
      if let posts = posts {
         self.posts = posts
      }
      if let error = error {
        self.onError?(error)
      }
    }
  }
  
  func writePost(post: Post, completion: @escaping (String?, Error?) -> Void) {
    guard isSignedIn else { return }
    
    DataManager.shared.newPost(post: post) { id, error in
      if let id = id {
        self.posts[id] = post
      }
      completion(id, error)
    }
  }
  
  func removePost(id: String, completion: @escaping (Error?) -> Void) {
    guard isSignedIn else { return }
    
    DataManager.shared.removeDocument(id: id) { error in
      completion(error)
    }
  }
  
  
  func getPostByDate() -> [(String, Post)] {
    return posts.sorted { post1, post2 in
      post1.value.date > post2.value.date
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
    } catch {
      let error = NSError(domain: "com.congtung.TwitterDemo", code: 1, userInfo: ["message": "User already logged out"])
      onError?(error)
    }
  }
  
}
