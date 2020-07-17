//
//  ViewController.swift
//  TwitterDemo
//
//  Created by TungHC on 7/17/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit

protocol HomeViewModelProtocol: class {
  func post()
  func fetch(completion: ([Post]) -> Void)
}

class HomeViewModel : HomeViewModelProtocol {
  func post() {
    
  }
  
  func fetch(completion: ([Post]) -> Void) {
    
  }
}
class HomeViewController: UIViewController {
  var model: HomeViewModelProtocol!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  
}

