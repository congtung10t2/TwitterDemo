//
//  UIViewController+Extensions.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit

extension UIViewController {
  func showAlert(title: String, message : String) {
    DispatchQueue.main.async(execute: {
      let alertController = UIAlertController(title: title, message:
        message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alertController, animated: true, completion: nil)
    })
  }
}
