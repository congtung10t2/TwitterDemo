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
  func onAuthStateListener()
  var onError: ((Error) -> Void)? { get set }
  var onSignIn:(() -> Void)? { get set }
  func signIn(email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?)
}

class LoginViewModel : LoginViewModelProtocol {
  var handle: AuthStateDidChangeListenerHandle?
  var onError: ((Error) -> Void)?
  var onSignIn:(() -> Void)?
  func onAuthStateListener() {
    handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
      if UserManager.shared.isSignedIn() {
        self?.onSignIn?()
      }
    }
    
  }
  func signIn(email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
    FirebaseAPI.shared.login(email: email, password: password) {[weak self] (auth, error) in
      guard let self = self else { return }
      if let error = error {
        self.onError?(error)
      }
      if auth != nil {
        self.onSignIn?()
      }
      completion?(auth, error)
    }
  }
  deinit {
    if let handle = handle {
      Auth.auth().removeStateDidChangeListener(handle)
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
  
  override func viewWillAppear(_ animated: Bool) {
    if UserManager.shared.isSignedIn() {
      self.present(HomeViewController.instantiate, animated: true, completion: nil)
    }
  }
  
  @IBAction func onLogin(_ sender: Any) {
    guard let username = usernameTextField.text,
      let password = passwordTextField.text else { return }
    let loading = showLoading()
    model.signIn(email: username, password: password) { (auth, error) in
      loading.hide(animated: true)
    }
  }
  func setupView() {
    model.onSignIn = { [weak self] in
      self?.present(HomeViewController.instantiate, animated: true, completion: nil)
    }
    model.onError = { [weak self] error in
      self?.showAlert(title: "Demo", message: error.localizedDescription)
    }
    model.onAuthStateListener()
    
  }

}
