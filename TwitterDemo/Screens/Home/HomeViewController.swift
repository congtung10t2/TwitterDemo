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
  var isSignedIn: Bool { get set }
  func post()
  func fetch(completion: ([Post]) -> Void)
  func writePost(post: Post)
}

class HomeViewModel : HomeViewModelProtocol {
  var posts: [Post]?
  var isSignedIn: Bool = true
  func post() {
    
  }
  
  func fetch(completion: ([Post]) -> Void) {
    
  }
  
  func writePost(post: Post) {
    guard isSignedIn else { return }
    posts?.append(post)
  }
  
}
class HomeViewController: UIViewController {
  var model: HomeViewModelProtocol = HomeViewModel()
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    // Do any additional setup after loading the view.
  }
  
  func setupView(){
    tableView.register(PostViewCell.self)
    tableView.register(WritingViewCell.self)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView(frame: .zero)
    
  }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if model.isSignedIn {
      return (model.posts?.count ?? 0) + 1
    }
    return model.posts?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIndexForSigned: Int = model.isSignedIn ? 1 : 0
    
    if indexPath.row == 0 && model.isSignedIn {
      let cell: WritingViewCell = tableView.dequeueReusableCell(for: indexPath)
      return cell
    }
    let cell: PostViewCell = tableView.dequeueReusableCell(for: indexPath)
    if let posts = model.posts {
      cell.load(post: posts[indexPath.row - cellIndexForSigned])
    }
    return cell
  }
}

