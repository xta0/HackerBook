/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

extension String {
  func trimHTMLTags() -> String? {
    guard let htmlStringData = self.data(using: String.Encoding.utf8) else {
      return nil
    }
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ]
    let attributedString = try? NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
    return attributedString?.string
  }
}

extension Int {
  func timestampString(formatter: DateComponentsFormatter) -> String? {
    let currentDate = Date()
    let timestamp = TimeInterval(self)
    let date = Date(timeIntervalSince1970: timestamp)
    let differenceInSeconds = currentDate.timeIntervalSince(date)
    if let timeString = formatter.string(from: differenceInSeconds) {
      return "\(timeString) ago"
    }
    return nil
  }
}
