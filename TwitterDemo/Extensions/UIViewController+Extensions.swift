//
//  UIViewController+Extensions.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/18/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
  func showAlert(title: String, message : String) {
    let alertController = UIAlertController(title: title, message:
      message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    DispatchQueue.main.async(execute: {
      self.present(alertController, animated: true, completion: nil)
    })
  }
  func showLoading() -> MBProgressHUD {
    return MBProgressHUD.showAdded(to: self.view, animated: true);
  }
  
  func showAlert(title: String, message: String, handler: (() -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default) { _ in
      guard let handler = handler else { return }
      handler()
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    alert.addAction(action)
    alert.addAction(cancel)
    DispatchQueue.main.async(execute: {
      self.present(alert, animated: true, completion: nil)
    })
  }
  
}

