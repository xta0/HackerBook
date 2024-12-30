/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ExclusiveNewsView: View {
  @ObservedObject var networkManager = NetworkManager()
  var body: some View {
    Container {
      List(networkManager.posts.indices, id: \.self) { index in
        PostView(post: networkManager.posts[index])
          .onAppear(perform: {
            if index == networkManager.posts.count - 1 {
              self.fetchData()
            }
          })
      }
    }.navigationBarTitle("Exclusive News", displayMode: .inline)
    .onAppear {
      self.fetchData()
    }
  }

  @ViewBuilder
  private func Container<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    if #available(iOS 15.0, *) {
      content()
        .refreshable {
          self.networkManager.rest()
          self.fetchData()
        }
    } else {
      content()
    }
  }

  func fetchData() {
    networkManager.fetchTopStory(url: HNContext.Network.excusiveNewsURL.rawValue)
  }
}

struct ExclusiveNewsView_Previews: PreviewProvider {
  static var previews: some View {
    ExclusiveNewsView()
  }
}
