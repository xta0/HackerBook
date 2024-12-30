/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  let urlString: String?
  typealias UIViewType = WKWebView

  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  func updateUIView(_ uiView: UIViewType, context: Context) {
    if let safeString = urlString {
      if safeString.starts(with: "http//") || safeString.starts(with: "https://") {
        if let url = URL(string: safeString) {
          let request = URLRequest(url: url)
          uiView.load(request)
        }
      } else {
        // render local html file
        let folderPath = Bundle.main.bundlePath
        let baseUrl = URL(fileURLWithPath: folderPath, isDirectory: true)
        let htmlString = (try? NSString(contentsOfFile: safeString, encoding: String.Encoding.utf8.rawValue)) ?? ""
        uiView.loadHTMLString(htmlString as String, baseURL: baseUrl)
      }
    }
  }
}
