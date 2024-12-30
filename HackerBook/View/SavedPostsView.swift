/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import SwiftUI

struct SavedPostsView: View {
  @ObservedObject var postsManager = SavedPostsManager.shared
  @State private var showBrowserView = false
  var body: some View {
    List {
      ForEach(postsManager.posts) { post in
        NavigationLink(destination: BrowserView(url: post.url), isActive: $showBrowserView) {
          VStack(alignment: .leading, spacing: 10, content: {
            VStack(alignment: .leading, content: {
              Text(post.urlHost ?? "")
                .font(.system(size: 12))
                .foregroundColor(.blue)
                .onTapGesture {
                  self.showBrowserView.toggle()
                }
            })
            VStack(alignment: .leading, spacing: 10, content: {
              Text(post.title ?? "")
                .font(.system(size: 18, design: .rounded))
                .lineLimit(nil)
              HStack(spacing: 5, content: {
                Text(post.author)
                  .font(.system(size: 14))
                Text("•")
                  .font(.system(size: 14))
                Text(post.createdTime ?? "")
                  .font(.system(size: 14))
              })
            })
          })
        }
      }.onDelete(perform: { indexSet in
        postsManager.removePostAtOffset(indexSet)
      })
    }.onAppear {
      postsManager.fetchSavedPosts()
    }
  }
}
