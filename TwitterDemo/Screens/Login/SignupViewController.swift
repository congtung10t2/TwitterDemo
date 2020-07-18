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
  func signup(email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)? )
  var signedUp: (()-> Void)? { get set }
  var onError: ((Error) -> Void)? { get set }
}

class SignupViewModel : SignupViewModelProtocol {
  var handle: AuthStateDidChangeListenerHandle?
  var onError: ((Error) -> Void)?
  var signedUp: (()-> Void)?
  init() {
    self.onAuthStateChanged()
  }
  func onAuthStateChanged() {
    handle = Auth.auth().addStateDidChangeListener { (auth, user) in
      print(auth)
      if UserManager.shared.isSignedIn() {
        self.signedUp?()
      }
    }
  }
  func signup(email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)? ) {
    FirebaseAPI.shared.signup(email: email, password: password) { (auth, error) in
      if let error = error {
        self.onError?(error)
      }
      if auth != nil {
        self.signedUp?()
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

class SignupViewController: UIViewController {
  var model: SignupViewModelProtocol = SignupViewModel()
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    // Do any additional setup after loading the view.
  }
  
  func setupView() {
    model.onError = { error in
      self.showAlert(title: "Demo", message: error.localizedDescription)
    }
    model.signedUp = {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func onSignupTap(_ sender: Any) {
    guard let email = userNameTextField.text,
      let password = passwordTextField.text else { return }
    let loading = showLoading()
    model.signup(email: email, password: password) { auth, error in
      loading.hide(animated: true)
    }
  }
  @IBAction func onDismissed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}
