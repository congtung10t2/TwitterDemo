//
//  ViewController.swift
//  TwitterDemo
//
//  Created by TungHC on 7/17/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit

protocol HomeViewModelProtocol: class {
  var posts: [Post]? { get set }
  func post()
  func fetch(completion: ([Post]) -> Void)
  func writePost(post: Post)
}

class HomeViewModel : HomeViewModelProtocol {
  var posts: [Post]?
  func post() {
    
  }
  
  func fetch(completion: ([Post]) -> Void) {
    
  }
  
  func writePost(post: Post) {
    posts?.append(post)
  }
  
}
class HomeViewController: UIViewController {
  var model: HomeViewModelProtocol = HomeViewModel()
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  func setupView(){
    tableView.register(PostViewCell.self)
    tableView.delegate = self
    tableView.dataSource = self
  }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.posts?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: PostViewCell = tableView.dequeueReusableCell(for: indexPath)
    return cell
  }
}

