/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import StoreKit
import SwiftUI

@available(iOS 16.0, *)
struct AccountView: View {
  @State private var showProcessView = false
  @State private var showRestoreAlert = false
  @State private var showSubscriptionAlert = false
  @Environment(\.requestReview) var requestReview

  var body: some View {
    VStack {
      List {
        Section {
          if PurchaseManager.shared.isPurchased(product: ProductID.ExclusiveNewsSub) {
            NavigationLink(destination: ExclusiveNewsView()) {
              Text("View Exclusive News")
            }
          } else {
            HStack {
              Text("🔓").font(.system(size: 14))
              VStack(alignment: .leading, spacing: 5, content: {
                Text("Unlock HackerBook Premium").font(.system(size: 14)).bold()
                Text("Become a subscriber to unlock more exclusive news ($2.99/month)").font(.system(size: 12))
              })
            }.onTapGesture {
              self.showProcessView = true
              PurchaseManager.shared.purchase(product: .ExclusiveNewsSub) { success, error in
                self.showProcessView = false
                if success {
                  self.showSubscriptionAlert = true
                }
              }
            }
          }
        } header: {
          Text("Premium")
        }
        Section {
          NavigationLink(destination: SavedPostsView()) {
            Text("🔖 Saved News")
          }
        } header: {
          Text("History")
        }
        Section {
          NavigationLink(destination: FeedbackView()) {
            Text("📝 Help and Feedback")
          }
          NavigationLink(destination: TipsView()) {
            Text("🧧 Tip Jar")
          }
          let privacyURL = Bundle.main.path(forResource: "PrivacyPolicy", ofType: ".html")
          NavigationLink(destination: BrowserView(url: privacyURL)) {
            Text("🔒 Privacy Policy")
          }
        } header: {
          Text("Help")
        }
        Section {
          HStack {
            Text("⭐️").font(.system(size: 18))
            Text("Leave a Review").font(.system(size: 18))
          }.onTapGesture {
            requestReview()
          }
        } header: {
          Text("Review")
        }
        Section {
          Button("Restore your subscription") {
            if PurchaseManager.shared.isPurchased(product: ProductID.ExclusiveNewsSub) {
              showRestoreAlert = true
              return
            }
            showProcessView = true
            PurchaseManager.shared.restorePurchase(product: ProductID.ExclusiveNewsSub) { success, error in
              showProcessView = false
              if success {
                showRestoreAlert = true
              }
            }
          }
        } header: {
          Text("In App Purchase")
        } footer: {
          if showProcessView {
            HStack {
              Spacer()
              ProgressView()
              Spacer()
            }
          }
        }
      }.navigationBarTitle("Account", displayMode: .inline).onAppear()
      .alert(isPresented: $showSubscriptionAlert) {
        Alert(title: Text("In App Purchase"), message: Text("Successful!"), dismissButton: .cancel())
      }.alert(isPresented: $showRestoreAlert) {
        Alert(title: Text("In App Purchase"), message: Text("Your purchase has been restored"), dismissButton: .default(Text("Got it!")))
      }
      NavigationLink(destination: BrowserView(url: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")) {
        Text("Term of Use")
      }
    }
  }
}

struct AccountView_Previews: PreviewProvider {
  static var previews: some View {
    if #available(iOS 16.0, *) {
      AccountView()
    } else {
      // Fallback on earlier versions
    }
  }
}
