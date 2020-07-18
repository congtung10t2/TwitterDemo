//
//  WritingViewCell.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit

enum WritingViewState {
  case NoContent
  case Postable
}

protocol WritingViewCellDelegate: class {
  func onPosted(post: Post)
}

class WritingViewCell: UITableViewCell {
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var contentTextField: UITextField!
  @IBOutlet weak var postButton: UIButton!
  weak var delegate: WritingViewCellDelegate?
  var state: WritingViewState = .NoContent {
    didSet {
      if state != oldValue {
        updateStateChanged()
      }
    }
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
    updateStateChanged()
  }
  
  func updateStateChanged() {
    switch state {
    case .NoContent:
      postButton.isEnabled = false
      postButton.titleLabel?.textColor = .gray
    case .Postable:
      postButton.isEnabled = true
      postButton.titleLabel?.textColor = .link
    }
  }
  
  @objc func onPost(_ sender: UIEvent) {
    guard let text = contentTextField.text else { return }
    delegate?.onPosted(post: Post(content: text))
    contentTextField.text = ""
  }
  
  func setupView() {
    contentTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    photoImageView.makeRounded()
    postButton.addTarget(self, action: #selector(onPost(_:)), for: .touchUpInside)
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    guard let text = textField.text else { return }
    if text.count > 0 {
      state = .Postable
    } else {
      state = .NoContent
    }
  }
  
}

