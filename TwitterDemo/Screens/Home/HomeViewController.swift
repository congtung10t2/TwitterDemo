//
//  ViewController.swift
//  TwitterDemo
//
//  Created by TungHC on 7/17/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit
import FirebaseAuth
import MaterialComponents.MaterialActionSheet

final class HomeViewController: UIViewController {
  var model: HomeViewModelProtocol = HomeViewModel()
  @IBOutlet weak var tableView: UITableView!
  var edittingId: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    loadApi()
  }
  func onListenError(){
    model.onError = {[weak self] error in
      self?.showAlert(title: "Demo", message: error.localizedDescription)
    }
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
  
  func onPostDeleting(id: String) {
    
    showAlert(title: "Demo", message: "Are you sure want to delete this Post?") { [weak self] in
      guard let self = self else { return }
      let loading = self.showLoading()
      self.model.removePost(id: id) { error in
        loading.hide(animated: true)
        guard let error = error else {
          self.model.posts[id] = nil
          self.tableView.reloadData()
          return
        }
        self.model.onError?(error)
      }
    }
    
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
    cell.delegate = self
    let post = posts[indexPath.row - cellIndexForSigned]
    cell.load(id: post.0, post: post.1)
    cell.layoutIfNeeded()
    return cell
  }
}
extension HomeViewController: WritingViewCellDelegate {
  func onPosted(post: Post) {
    let loading = showLoading()
    model.writePost(post: post) { (post, error)  in
      loading.hide(animated: true)
      self.tableView.reloadData()
    }
  }
}

extension HomeViewController: PostViewCellDelegate {
  func onPostEditting(_ view: PostViewCell) {
    edittingId = view.postId
    if let id = edittingId {
      showActionSheet(id: id)
    }
  }
  func showActionSheet(id: String) {
    let actionSheet = MDCActionSheetController(title: "Editting",
                                               message: "You can update or edit your post")
    let actionOne = MDCActionSheetAction(title: "Delete",
                                         image: UIImage(named: "Delete"),
                                         handler: {_ in
                                          self.onPostDeleting(id: id)
                                          
    })
    let actionTwo = MDCActionSheetAction(title: "Edit",
                                         image: UIImage(named: "Edit"),
                                         handler: {_ in
                                          let editVc = EditPostViewController.instantiate
                                          editVc.model.setup(id: id, content: self.model.posts[id]?.content)
                                          editVc.delegate = self
                                          self.present(editVc, animated: true, completion: nil)
                                          
    })
    actionSheet.addAction(actionOne)
    actionSheet.addAction(actionTwo)
    
    present(actionSheet, animated: true, completion: nil)
  }
}
extension HomeViewController: EditPostDelegate {
  func onEdittedPost(content: String) {
    guard let edittingId = edittingId else { return }
    self.model.posts[edittingId]?.content = content
  }
}
extension HomeViewController: Storyboardable {
    static var board: StoryboardEnumerable {
      return StoryboardType.homeScreen
    }
}
