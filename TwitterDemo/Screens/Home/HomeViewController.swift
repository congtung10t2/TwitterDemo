//
//  ViewController.swift
//  TwitterDemo
//
//  Created by TungHC on 7/17/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol HomeViewModelProtocol: class {
  var posts: [Post] { get set }
  var loadedData: (() -> ())? { get set }
  var isSignedIn: Bool { get }
  func fetchAllPosts()
  func writePost(post: Post, completion: @escaping (Post?, Error?) -> Void)
  func getPostByDate() -> [Post]
  func signOut()
}

class HomeViewModel : HomeViewModelProtocol {
  var loadedData: (() -> ())?
  var posts: [Post] = [] {
    didSet {
      loadedData?()
    }
  }
  var isSignedIn: Bool {
    return UserManager.shared.isSignedIn()
  }
  
  func fetchAllPosts() {
    DataManager.shared.fetchAll() { (posts, error) in
      if let posts = posts {
         self.posts = posts
      }
    }
  }
  
  func writePost(post: Post, completion: @escaping (Post?, Error?) -> Void) {
    guard isSignedIn else { return }
    
    DataManager.shared.newPost(post: post) { post, error in
      if let post = post {
        self.posts.append(post)
      }
      completion(post, error)
    }
    
  }
  
  func getPostByDate() -> [Post] {
    return posts.sorted {
      $0.date > $1.date
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
    } catch {
      print("already logged out")
    }
  }
  
}
final class HomeViewController: UIViewController {
  var model: HomeViewModelProtocol = HomeViewModel()
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    loadApi()
    // Do any additional setup after loading the view.
  }
  
  func loadApi() {
    model.fetchAllPosts()
    model.loadedData = { [weak self] in
      self?.tableView.reloadData()
    }
  }
  
  @IBAction func onSignedOut(_ sender: Any) {
    model.signOut()
    dismiss(animated: true, completion: nil)
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
    model.writePost(post: post) { (post, error)  in
      self.tableView.reloadData()
    }
  }
}

extension HomeViewController: Storyboardable {
    static var board: StoryboardEnumerable {
      return StoryboardType.homeScreen
    }
}
