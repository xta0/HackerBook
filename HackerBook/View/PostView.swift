/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct PostView: View {
  let post: Post
  @State private var showDetailedView = false
  @State private var showBrowserView = false
  var body: some View {
    VStack(alignment: .leading, spacing: 10, content: {
      VStack(alignment: .leading, content: {
        Text(post.urlHost ?? "")
          .font(.system(size: 12))
          .foregroundColor(.blue)
          .onTapGesture {
            self.showBrowserView.toggle()
          }
      }).background(NavigationLink(destination: BrowserView(url: post.url), isActive: $showBrowserView) {
        EmptyView()
      }.hidden())
      VStack(alignment: .leading, spacing: 10, content: {
        Text(post.title)
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
        HStack(spacing: 5, content: {
          Text("↑ " + String(post.points))
            .font(.system(size: 14))
            .foregroundColor(.orange)
          Text("•")
            .font(.system(size: 14))
          Text(String(post.nComments) + " comments")
            .font(.system(size: 14))
        })
      })
    })
    .onTapGesture {
      self.showDetailedView.toggle()
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .background(NavigationLink(destination: DetailedView(objectID: post.objectID), isActive: $showDetailedView) {
      EmptyView()
    }.hidden()).onTapGesture {
      self.showDetailedView.toggle()
    }
  }
}
