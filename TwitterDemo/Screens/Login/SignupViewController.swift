//
//  SignupViewController.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

protocol SignupViewModelProtocol: class {
  func onAuthStateChanged()
  func signup(email: String, password: String)
}

class SignupViewModel : SignupViewModelProtocol {
  var handle: AuthStateDidChangeListenerHandle?
  init() {
    self.onAuthStateChanged()
  }
  func onAuthStateChanged() {
    handle = Auth.auth().addStateDidChangeListener { (auth, user) in
      
    }
  }
  func signup(email: String, password: String) {
    FirebaseAPI.shared.signup(email: email, password: password) {_,_ in
      
    }
  }
}

class SignupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }


}
