//
//  WritingViewCell.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit
class WritingViewCell: UITableViewCell {
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var contentTextField: UITextField!
  @IBOutlet weak var postButton: UIButton!
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  func setupView() {
    photoImageView.makeRounded()
  }
  
}

