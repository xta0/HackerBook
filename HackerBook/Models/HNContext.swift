/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

enum HNContext {
  enum Network: String {
    case topStoryURL = "https://hn.algolia.com/api/v1/search?tags=front_page"
    case excusiveNewsURL = "https://hn.algolia.com/api/v1/search?query=exclusive&tags=story"
    case storyURL = "https://hn.algolia.com/api/v1/items/"
  }
}
