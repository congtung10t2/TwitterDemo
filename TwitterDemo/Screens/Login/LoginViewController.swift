//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by TungHC on 7/17/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol LoginViewModelProtocol: class {
  func onAuthStateChanged()
  func signIn(email: String, password: String)
}

class LoginViewModel : LoginViewModelProtocol {
  var handle: AuthStateDidChangeListenerHandle?
  func onAuthStateChanged() {
    handle = Auth.auth().addStateDidChangeListener { (auth, user) in
      
    }
  }
  func signIn(email: String, password: String) {
    FirebaseAPI.shared.login(email: email, password: password) {_,_ in
      
    }
  }
}

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }


}