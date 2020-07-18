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
  func newPost(post: Post, completion: @escaping (String?, Error?) -> Void)   {
    let newPostRef = db.collection("posts").document()
    do {
      try newPostRef.setData(from: post)
      completion(newPostRef.documentID, nil)
    } catch let error {
      completion(nil, error)
    }
  }
  
  func fetchAll(completion: @escaping ([String: Post]?, Error?) -> Void) {
    db.collection("posts").getDocuments() { (querySnapshot, error) in
      if let error = error {
        completion(nil, error)
      } else {
        let posts = querySnapshot!.documents.reduce(into: [String: Post]()) {
          let data = try? $1.data(as: Post.self)
          $0[$1.documentID] = data
        }
        completion(posts, nil)
      }
    }
  }
  
  func removeDocument(id: String, completion: @escaping (Error?) -> Void) {
    db.collection("posts").document(id).delete() { err in
      completion(err)
    }
  }
}
