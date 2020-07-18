//
//  Post.swift
//  TwitterDemo
//
//  Created by tùng hoàng on 7/17/20.
//  Copyright © 2020 Tunghc. All rights reserved.
//

import Foundation

struct Post: Codable {
  var content: String
  var author: String
  var date: Date
}

extension Post {
  init(content: String) {
    self.content = content
    self.author = UserManager.shared.getDisplayName() ?? ""
    self.date = Date()
    print(date)
  }
}
