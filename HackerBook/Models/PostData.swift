/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

struct Results: Decodable {
  var hits: [Post]
  let nbPages: Int
  let page: Int
  let nbHits: Int
  let hitsPerPage: Int
}

struct Post: Decodable, Identifiable {
  var id: String {
    return objectID
  }
  var nComments: Int {
    return num_comments ?? 0
  }
  var urlHost: String? {
    return URL(string: url ?? "https://news.ycombinator.com")?.host
  }
  var createdTime: String?
  let objectID: String
  let points: Int
  let title: String
  let url: String?
  let created_at_i: Int
  let num_comments: Int?
  let author: String
}
