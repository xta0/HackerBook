/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

enum ProductID: String {
  case ExclusiveNewsSub = "exclusive_news_monthly_subscription"
  case ExclusiveNewsOneTime = "exclusive_news_one_time"
  case TipsJar = "com.hackerbook.tips"
}

enum TransactionStatus {
  case Successful(ProductID)
  case Unsuccessful(ProductID)
}

class PurchaseManager {

  private var prurchaseCompletion: ((Bool, Error?) -> Void)?
  private var purchaseRestoreCompletion: ((Bool, Error?) -> Void)?

  private(set) var purchaseStatus: TransactionStatus = .Unsuccessful(.ExclusiveNewsSub)

  static let shared = PurchaseManager()

  let transactionManager: TransactionManager?

  private init() {
    transactionManager = TransactionManager()
    transactionManager?.delegate = self
  }

  func isPurchased(product: ProductID) -> Bool {
    // only applicable for subscription
    if product == .ExclusiveNewsSub {
      return UserDefaults.standard.bool(forKey: product.rawValue)
    }
    return false
  }

  func purchase(product: ProductID, completion: @escaping (Bool, Error?) -> Void) {
    prurchaseCompletion = completion
    if isPurchased(product: product) {
      prurchaseCompletion?(true, nil)
      return
    }
    transactionManager?.purchase(productIdentifier: product.rawValue)
  }

  func restorePurchase(product: ProductID, completion: @escaping (Bool, Error?) -> Void) {
    purchaseRestoreCompletion = completion
    transactionManager?.restorePurchase()
  }
}

extension PurchaseManager: TransactionManagerObserver {
  func transactionDidFinish(productID: String?) {
    guard let productID else {
      return
    }
    if productID == ProductID.ExclusiveNewsSub.rawValue {
      purchaseStatus = .Successful(.ExclusiveNewsSub)
      UserDefaults.standard.set(true, forKey: ProductID.ExclusiveNewsSub.rawValue)
    } else if productID == ProductID.ExclusiveNewsOneTime.rawValue {
      purchaseStatus = .Successful(.ExclusiveNewsOneTime)
      UserDefaults.standard.set(true, forKey: ProductID.ExclusiveNewsOneTime.rawValue)
    } else if productID == ProductID.TipsJar.rawValue {
      purchaseStatus = .Successful(.TipsJar)
      UserDefaults.standard.set(true, forKey: ProductID.TipsJar.rawValue)
    }
    prurchaseCompletion?(true, nil)
  }

  func transactionDidFail(productID: String?, error: Error) {
    guard let productID else {
      return
    }
    if productID == ProductID.ExclusiveNewsSub.rawValue {
      purchaseStatus = .Unsuccessful(.ExclusiveNewsSub)
    } else if productID == ProductID.ExclusiveNewsOneTime.rawValue {
      purchaseStatus = .Unsuccessful(.ExclusiveNewsOneTime)
    } else if productID == ProductID.TipsJar.rawValue {
      purchaseStatus = .Unsuccessful(.TipsJar)
    }
    prurchaseCompletion?(false, error)
  }

  func transactionDidRestored(productID: String?) {
    if productID == ProductID.ExclusiveNewsSub.rawValue {
      UserDefaults.standard.set(true, forKey: ProductID.ExclusiveNewsSub.rawValue)
    }
    purchaseRestoreCompletion?(true, nil)
  }
}
