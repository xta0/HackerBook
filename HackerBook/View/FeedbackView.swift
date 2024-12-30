/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */


import SwiftUI

struct FeedbackView: View {
  @State private var name = ""
  @State private var event = ""
  @State private var feedback = ""
  @State private var showCompletionAlert = false
  @State private var showingSurveyViewController = false
  var body: some View {
    VStack(alignment: .leading, spacing: 5, content: {
      Form {
        Section(header: Text("Name")) {
          TextField("", text: $name)
        }
        Section(header: Text("Event")) {
          TextField("", text: $event)
        }
        Section(header: Text("Feedback")) {
          TextField("", text: $feedback)
        }
      }
      Button(action: {
        self.showCompletionAlert = true
      }) {
        Text("Submit")
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(8)
      }
      .padding([.top, .leading, .trailing])
    }).navigationBarTitle("Feedback", displayMode: .inline)
    .navigationBarItems(trailing: Button(action: {
      showingSurveyViewController = true
    }) {
      Text("Open Survey")
    })
    .sheet(isPresented: $showingSurveyViewController) {
      SurveyViewControllerRepresentable()
    }
    .alert(isPresented: $showCompletionAlert) {
      return Alert(title: Text("Thank you!"), message: Text("We have received your feedback!"), dismissButton: .default(Text("Got it")))
    }
  }
}

struct FeedbackView_Previews: PreviewProvider {
  static var previews: some View {
    FeedbackView()
  }
}
