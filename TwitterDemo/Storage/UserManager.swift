//
//  UserManager.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import FirebaseAuth
class UserManager {
  static let shared = UserManager()
  func getDisplayName() -> String? {
    return Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email ?? ""
  }
  
  func isSignedIn() -> Bool {
    return Auth.auth().currentUser != nil
  }
}
