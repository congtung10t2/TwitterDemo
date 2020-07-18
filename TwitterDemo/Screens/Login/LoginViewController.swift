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
  var onError: ((Error) -> Void)? { get set }
  var onSignIn:(() -> Void)? { get set }
  func signIn(email: String, password: String)
}

class LoginViewModel : LoginViewModelProtocol {
  var handle: AuthStateDidChangeListenerHandle?
  var onError: ((Error) -> Void)?
  var onSignIn:(() -> Void)?
  func onAuthStateChanged() {
    handle = Auth.auth().addStateDidChangeListener { (auth, user) in
      
    }
    
  }
  func signIn(email: String, password: String) {
    FirebaseAPI.shared.login(email: email, password: password) {[weak self] (auth, error) in
      guard let self = self else { return }
      if let error = error {
        self.onError?(error)
      }
      if auth != nil {
        self.onSignIn?()
      }
    }
  }
}

class LoginViewController: UIViewController {
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  var model: LoginViewModelProtocol = LoginViewModel()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    // Do any additional setup after loading the view.
  }
  @IBAction func onLogin(_ sender: Any) {
    guard let username = usernameTextField.text,
      let password = passwordTextField.text else { return }
    model.signIn(email: username, password: password)
  }
  func setupView() {
    model.onSignIn = {
      self.present(HomeViewController.instantiate, animated: true, completion: nil)
    }
    model.onError = { error in
      print(error)
    }
    if UserManager.shared.isSignedIn() {
      self.present(HomeViewController.instantiate, animated: true, completion: nil)
    }
  }

}
