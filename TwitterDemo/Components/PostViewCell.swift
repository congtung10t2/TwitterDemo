//
//  PostViewCell.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialActionSheet
protocol PostViewCellDelegate: class {
  func onPostEditting(_ view: PostViewCell)
}
class PostViewCell: UITableViewCell {
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var dateLabel: UILabel!
  var postId: String?
  weak var delegate: PostViewCellDelegate?
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  func setupView() {
    photoImageView.makeRounded()
  }
  @IBAction func onEditting(_ sender: Any) {
    delegate?.onPostEditting(self)
  }
  
  func load(id: String, post: Post) {
    self.postId = id
    editButton.isHidden = !(post.author == UserManager.shared.getDisplayName())
    userNameLabel.text = post.author
    contentTextView.text = post.content
    dateLabel.text = post.date.timeAgoDisplay()
  }
}
