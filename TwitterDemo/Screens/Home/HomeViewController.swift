//
//  ViewController.swift
//  TwitterDemo
//
//  Created by TungHC on 7/17/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit

protocol HomeViewModelProtocol: class {
  var posts: [Post] { get set }
  var isSignedIn: Bool { get set }
  func fetch(completion: ([Post]) -> Void)
  func writePost(post: Post, completion: @escaping (Post) -> Void)
  func getPostByDate() -> [Post]
  func signOut()
}

class HomeViewModel : HomeViewModelProtocol {
  var posts: [Post] = []
  var isSignedIn: Bool = true
  
  func fetch(completion: ([Post]) -> Void) {
    
  }
  
  func writePost(post: Post, completion: @escaping (Post) -> Void) {
    guard isSignedIn else { return }
    posts.append(post)
    completion(post)
  }
  
  func getPostByDate() -> [Post] {
    return posts.sorted {
      $0.date > $1.date
    }
  }
  
  func signOut() {
    
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
      return model.posts.count + 1
    }
    return model.posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIndexForSigned: Int = model.isSignedIn ? 1 : 0
    
    if indexPath.row == 0 && model.isSignedIn {
      let cell: WritingViewCell = tableView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      return cell
    }
    let cell: PostViewCell = tableView.dequeueReusableCell(for: indexPath)
    let posts = model.getPostByDate()
    cell.load(post: posts[indexPath.row - cellIndexForSigned])
    return cell
  }
}
extension HomeViewController: WritingViewCellDelegate {
  func onPosted(post: Post) {
    model.writePost(post: post) { post in
      self.tableView.reloadData()
    }
  }
}

