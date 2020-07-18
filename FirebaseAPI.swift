//
//  FirebaseAPI.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirebaseAuthProtocol {
  func login(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void)
  func signup(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void)
}

class FirebaseAPI: FirebaseAuthProtocol {
  static let shared = FirebaseAPI()
  func login(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      completion(authResult, error)
    }
  }
  
  func signup(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      completion(authResult, error)
    }
  }
}

