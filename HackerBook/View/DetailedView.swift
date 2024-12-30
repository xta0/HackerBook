/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct DetailedView: View {
  @ObservedObject var networkManager = NetworkManager()
  @State private var showBrowserView = false
  @State private var isPostSaved = false
  var objectID: String?
  var body: some View {
    let objectData = networkManager.objectData
    VStack {
      if objectData == nil {
        VStack {
          Spacer()
          ProgressView()
          Spacer()
        }
      } else {
        List {
          Section {
            VStack(alignment: .leading, spacing: 10, content: {
              Text(objectData?.title ?? "").font(.system(size: 16)).bold()
              VStack(alignment: .leading, content: {
                Text(objectData?.urlHost ?? "")
                  .font(.system(size: 12))
                  .foregroundColor(.blue)
                  .onTapGesture {
                    self.showBrowserView.toggle()
                  }
              }).background(NavigationLink(destination: BrowserView(url: objectData?.url), isActive: $showBrowserView) {
                EmptyView()
              }.hidden())
              Text(objectData?.plainText ?? "").font(.system(size: 14))
              HStack(spacing: 5.0) {
                Text("↑ " + String(objectData?.points ?? 0))
                  .font(.system(size: 14))
                Text("• " + (objectData?.author ?? ""))
                  .font(.system(size: 14))
                Text(objectData?.createdTime ?? "")
                  .font(.system(size: 14))
              }
            })
          }
          Section {
            ForEach(objectData?.children ?? []) { comment in
              let commentView = CommentView(objectID: String(comment.id ?? 0), comment: comment.plainText, replyCount: comment.children.count)
              NavigationLink(destination: commentView) {
                VStack(alignment: .leading, spacing: 10) {
                  HStack(spacing: 5) {
                    Text(comment.author ?? "")
                      .font(.system(size: 12))
                      .foregroundColor(.blue)
                    Text("• " + (comment.createdTime ?? ""))
                      .font(.system(size: 12))
                  }
                  Text(comment.plainText ?? "").font(.system(size: 14))
                  Text(String(comment.children.count) + " replies").font(.system(size: 14))
                }
              }
            }
          } header: {
            Text("Comments")
          }
        }
      }
    }.onAppear {
      networkManager.fetchStoryItem(id: objectID) { result in
        if let postData = result {
          self.isPostSaved = SavedPostsManager.shared.isPostSaved(postData)
        }
      }
    }
    .navigationBarTitle("News Detail", displayMode: .inline)
    .navigationTitle("Saved News")
    .navigationBarItems(
      trailing: networkManager.objectData != nil ? Button(action: {
        if let data = objectData {
          if isPostSaved {
            SavedPostsManager.shared.removePost(data)
          } else {
            SavedPostsManager.shared.savePost(data)
          }
          self.isPostSaved.toggle()
        }
      }) {
        Image(systemName: isPostSaved ? "heart.fill" : "heart")
      } : nil
    )
  }
}

extension DetailedView {
  init(objectID: String?) {
    self.objectID = objectID
  }
}

struct DetailedView_Previews: PreviewProvider {
  static var previews: some View {
    DetailedView(objectID: "37739028")
  }
}
