/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import SwiftUI

struct SurveyViewControllerRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = UINavigationController
  func makeUIViewController(context: Context) -> UINavigationController {
    let vc = SurveyViewController()
    vc.title = "Survey"
    let navigationController = UINavigationController(rootViewController: vc)
    return navigationController
  }
  func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    // no-op
  }
}
