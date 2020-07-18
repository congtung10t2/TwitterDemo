//
//  PostViewCell.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit
class PostViewCell: UITableViewCell {
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var contentTextView: UITextView!
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  func setupView() {
    photoImageView.makeRounded()
  }
  
  func load(post: Post) {
    userNameLabel.text = post.author
    contentTextView.text = post.content
  }
}
