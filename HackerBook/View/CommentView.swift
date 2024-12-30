/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct CommentView: View {
  var objectID: String?
  var text: String?
  var replyCount: Int?
  @ObservedObject var networkManager = NetworkManager()
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
              Text(self.text ?? "").font(.system(size: 14))
              Text(String(self.replyCount ?? 0) + " replies").font(.system(size: 14))
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
    }.onAppear { networkManager.fetchStoryItem(id: objectID) }
    .navigationBarTitle("Comments", displayMode: .inline)
  }
}

extension CommentView {
  init(objectID: String?, comment: String?, replyCount: Int?) {
    self.objectID = objectID
    self.text = comment
    self.replyCount = replyCount
  }
}
