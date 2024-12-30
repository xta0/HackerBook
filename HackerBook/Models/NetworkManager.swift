/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

final class NetworkManager: ObservableObject {
  @Published var posts = [Post]()
  @Published var objectData: ObjectData?
  private var page = 0
  private var numberOfPages = 0

  private(set) lazy var dateFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
    formatter.maximumUnitCount = 1 // only show the most significant unit
    return formatter
  }()
}

extension NetworkManager {
  func fetchTopStory(url: String) {
    if page > numberOfPages {
      return
    }
    if let url = URL(string: "\(url)&page=\(page)") {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { data, response, error in
        if error == nil {
          let decoder = JSONDecoder()
          if let safeData = data {
            do {
              var results = try decoder.decode(Results.self, from: safeData)
              self.numberOfPages = results.nbPages
              // process the timestamp
              for (index, post) in results.hits.enumerated() {
                if let timeString = post.created_at_i.timestampString(formatter: self.dateFormatter) {
                  results.hits[index].createdTime = timeString
                }
              }
              DispatchQueue.main.async {
                self.posts += results.hits
                self.page += 1
              }
            } catch {
              print(error)
            }
          }
        }
      }
      task.resume()
    }
  }

  func rest() {
    page = 0
    numberOfPages = 0
    posts = []
  }
}

extension NetworkManager {
  func fetchStoryItem(id: String?, completion: ((ObjectData?) -> Void)? = nil) {
    guard let storeyID = id else {
      return
    }
    if let url = URL(string: "\(HNContext.Network.storyURL.rawValue)/\(storeyID)") {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { data, response, error in
        if error != nil {
          completion?(nil)
          return
        }
        let decoder = JSONDecoder()
        if let response = data {
          do {
            var result = try decoder.decode(ObjectData.self, from: response)
            result.plainText = result.text?.trimHTMLTags()
            result.createdTime = result.created_at_i?.timestampString(formatter: self.dateFormatter)
            // process the timestamp
            for (index, post) in result.children.enumerated() {
              if let timeString = post.created_at_i?.timestampString(formatter: self.dateFormatter) {
                result.children[index].createdTime = timeString
                result.children[index].plainText = result.children[index].text?.trimHTMLTags()
              }
            }
            DispatchQueue.main.async {
              self.objectData = result
            }
            completion?(result)
          } catch {
            print(error)
            completion?(nil)
          }
        }
      }
      task.resume()
    }
  }
}
