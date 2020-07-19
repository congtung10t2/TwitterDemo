//
//  EditPostViewController.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/19/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit

protocol EditPostProtocol {
  var postId: String? { get set }
  var content: String? { get set }
  func setup(id: String?, content: String?)
}

protocol EditPostDelegate: class {
  func onEdittedPost(content: String)
}

class EditPostViewModel: EditPostProtocol  {
  var postId: String?
  var content: String?
  func setup(id: String?, content: String?) {
    self.postId = id
    self.content = content
  }
}

final class EditPostViewController: UIViewController {
  @IBOutlet weak var contentTextView: UITextView!
  var model: EditPostProtocol = EditPostViewModel()
  weak var delegate: EditPostDelegate?
  override func viewDidLoad() {
    super.viewDidLoad()
    contentTextView.text = model.content ?? ""
  }
  @IBAction func onClose(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func onSavePost(_ sender: Any) {
    if let postId = model.postId,
       let content = contentTextView.text {
      let loading = showLoading()
      DataManager.shared.update(id: postId, content: content) {[weak self] error in
        guard let self = self else { return }
        loading.hide(animated: true)
        guard let error = error else {
          self.delegate?.onEdittedPost(content: content)
          self.dismiss(animated: true, completion: nil)
          return
        }
        self.showAlert(title: "Demo", message: error.localizedDescription)
      }
    }
  }
}

extension EditPostViewController: Storyboardable {
    static var board: StoryboardEnumerable {
      return StoryboardType.homeScreen
    }
}
