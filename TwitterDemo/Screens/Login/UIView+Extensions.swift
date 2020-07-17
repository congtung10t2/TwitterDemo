//
//  UIView+Extensions.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit
extension UIView {
  @discardableResult
  func fitting(view: UIView) -> Self {
      self.translatesAutoresizingMaskIntoConstraints = false
      topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
      rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
      bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      return self
  }
  @IBInspectable var cornerRadius: CGFloat {
      get {
          return layer.cornerRadius
      }

      set(newCornerRadius) {
          layer.masksToBounds = true
          layer.cornerRadius = newCornerRadius
      }
  }

}
