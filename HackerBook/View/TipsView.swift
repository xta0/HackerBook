/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct TipsView: View {
  @State private var showPaymentSucceesfulAlert = false
  @State private var showPaymentProgressView = false
  var body: some View {
    List {
      Section {
        VStack(alignment: .leading, spacing: 5, content: {
          Text("Want to buy me a coffee? HackerBook relies on your support to fund its development. Please consider supporting the app by leaving a tip below. Thank you!").font(.system(size: 16.0)).padding([.top])
          Button(action: {
            showPaymentProgressView = true
            PurchaseManager.shared.purchase(product: ProductID.TipsJar) { success, error in
              self.showPaymentProgressView = false
              if success {
                self.showPaymentSucceesfulAlert = true
              }
            }
          }) {
            Text("Kind Tip -> $0.99")
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(8)
          }
          .padding([.top, .leading, .trailing])
          Spacer()
        })
      } header: {
        Text("🧧 Tips")
      } footer: {
        if showPaymentProgressView {
          HStack {
            Spacer()
            ProgressView()
            Spacer()
          }
        }
      }
    }.alert(isPresented: $showPaymentSucceesfulAlert) {
      Alert(title: Text("In App Purchase"), message: Text("Successful!"), dismissButton: .default(Text("OK")))
    }
  }
}

struct TipsView_Previews: PreviewProvider {
  static var previews: some View {
    TipsView()
  }
}
