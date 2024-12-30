/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ContentView: View {
  @ObservedObject var networkManager = NetworkManager()
  @State private var showExclusiveNewsPage = false
  @State private var showAccountPage = false
  @State private var showSubscriptionAlert = false
  var body: some View {
    NavigationView {
      if networkManager.posts.count == 0 {
        VStack {
          Spacer()
          ProgressView()
          Spacer()
        }
      } else {
        Container {
          List(networkManager.posts.indices, id: \.self) { index in
            PostView(post: networkManager.posts[index])
              .onAppear(perform: {
                if index == networkManager.posts.count - 1 {
                  self.fetchData()
                }
              })
          }
          NavigationLink(destination: ExclusiveNewsView(), isActive: $showExclusiveNewsPage) {
            EmptyView()
          }
          if #available(iOS 16.0, *) {
            NavigationLink(destination: AccountView(), isActive: $showAccountPage) {
              EmptyView()
            }
          } else {
            // Fallback on earlier versions
          }
        }
        .navigationTitle("Trending News")
        .navigationBarItems(
          leading: Button(action: {
            self.showAccountPage = true
          }) {
            Image(systemName: "person.fill")
          },
          trailing: Button(action: {
            if PurchaseManager.shared.isPurchased(product: ProductID.ExclusiveNewsSub) {
              self.showExclusiveNewsPage = true
            } else {
              self.showSubscriptionAlert = true
            }
          }) {
            Image(systemName: "newspaper.fill")
          }
        )
      }
    }.alert(isPresented: $showSubscriptionAlert, content: {
      return Alert(title: Text("Premium Only"), message: Text("Want to see the exclusive news from insiders?"), primaryButton: .default(Text("Subscribe")) {
        self.showAccountPage = true
      }, secondaryButton: .cancel())
    })
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
    networkManager.fetchTopStory(url: HNContext.Network.topStoryURL.rawValue)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
