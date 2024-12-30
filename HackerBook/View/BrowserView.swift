/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import WebKit

struct BrowserView: View {

  let url: String?

  var body: some View {
    WebView(urlString: url)
  }
}

struct BrowserView_Previews: PreviewProvider {
  static var previews: some View {
    BrowserView(url: "https://www.google.com")
  }
}
