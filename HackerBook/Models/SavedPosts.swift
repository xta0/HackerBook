/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

final class SavedPostsManager: ObservableObject {
  let USERDEFAULT_KEY = "SavedPostsIDs"
  @Published var posts: [ObjectData] = []
  static let shared = SavedPostsManager()
}

extension SavedPostsManager {
  func fetchSavedPosts() {
    let postsData = UserDefaults.standard.array(forKey: USERDEFAULT_KEY) as? [Data]
    let transformedPosts = postsData?.compactMap {
      try? JSONDecoder().decode(ObjectData.self, from: $0)
    }
    posts = transformedPosts ?? []
  }
  func savePost(_ post: ObjectData) {
    if isPostSaved(post) {
      return
    }
    posts.append(post)
    var postsData = UserDefaults.standard.array(forKey: USERDEFAULT_KEY) as? [Data] ?? []
    if let data = try? JSONEncoder().encode(post) {
      postsData.append(data)
      UserDefaults.standard.setValue(postsData, forKey: USERDEFAULT_KEY)
    }
  }
  func removePost(_ object: ObjectData) {
    var idx = 0
    for (index, post) in posts.enumerated() {
      if post.id == object.id {
        idx = index
        break
      }
    }
    removePostAtOffset(IndexSet(integer: idx))
  }
  func removePostAtOffset(_ indexSet: IndexSet) {
    posts.remove(atOffsets: indexSet)
    var postsData = UserDefaults.standard.array(forKey: USERDEFAULT_KEY) as? [Data]
    postsData?.remove(atOffsets: indexSet)
    UserDefaults.standard.setValue(postsData, forKey: USERDEFAULT_KEY)
  }
  func isPostSaved(_ object: ObjectData) -> Bool {
    if posts.isEmpty {
      fetchSavedPosts()
    }
    for post in posts {
      if post.id == object.id {
        return true
      }
    }
    return false
  }
}
