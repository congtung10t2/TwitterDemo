//
//  DataManager.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class DataManager {
  static var shared = DataManager()
  var db: Firestore!
  func configurate() {
    let settings = FirestoreSettings()
    Firestore.firestore().settings = settings
    // [END setup]
    db = Firestore.firestore()
  }
  func newPost(post: Post, completion: @escaping (Post?, Error?) -> Void)   {
    let newPostRef = db.collection("posts").document()
    do {
      try newPostRef.setData(from: post)
      completion(post, nil)
    } catch let error {
      completion(nil, error)
    }
  }
  
  func fetchAll(completion: @escaping ([Post]?, Error?) -> Void) {
    db.collection("posts").getDocuments() { (querySnapshot, error) in
      if let error = error {
        completion(nil, error)
      } else {
        let posts = querySnapshot!.documents.compactMap({ data in
          try? data.data(as: Post.self)
        })
        completion(posts, nil)
      }
    }
  }
}
