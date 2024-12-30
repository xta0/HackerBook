/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

struct ObjectData: Codable, Identifiable {
  var plainText: String?
  var createdTime: String?
  let id: Int?
  let created_at: String?
  let created_at_i: Int?
  let type: String?
  let author: String
  let title: String?
  let url: String?
  let text: String?
  let points: Int?
  var children: [Comment]
}

extension ObjectData {
  var urlHost: String? {
    return URL(string: url ?? "https://news.ycombinator.com")?.host
  }
}

struct Comment: Codable, Identifiable {
  var createdTime: String?
  var plainText: String?
  let id: Int?
  let created_at: String?
  let created_at_i: Int?
  let type: String?
  let author: String?
  let title: String?
  let url: String?
  let text: String?
  let points: Int?
  let parent_id: Int?
  let story_id: Int?
  let children: [Comment]
}
