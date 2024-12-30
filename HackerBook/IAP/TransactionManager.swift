/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import StoreKit

protocol TransactionManagerObserver: AnyObject {
  func transactionDidFinish(productID: String?)
  func transactionDidFail(productID: String?, error: Error)
  func transactionDidRestored(productID: String?)
}

class TransactionManager: NSObject {
  weak var delegate: TransactionManagerObserver?

  override init() {
    super.init()
    defer {
      SKPaymentQueue.default().add(self)
    }
  }

  deinit {
    SKPaymentQueue.default().remove(self)
  }

  func purchase(productIdentifier: String) {
    guard SKPaymentQueue.canMakePayments() else {
      return
    }
    let paymentRequest = SKMutablePayment()
    paymentRequest.productIdentifier = productIdentifier
    SKPaymentQueue.default().add(paymentRequest)
  }

  func restorePurchase() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
}

extension TransactionManager: SKPaymentTransactionObserver {
  func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
    return true
  }

  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      if transaction.transactionState == .purchased {
        delegate?.transactionDidFinish(productID: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
      } else if transaction.transactionState == .failed {
        if let error = transaction.error {
          delegate?.transactionDidFail(productID: transaction.payment.productIdentifier, error: error)
        }
        SKPaymentQueue.default().finishTransaction(transaction)
      } else if transaction.transactionState == .restored {
        delegate?.transactionDidRestored(productID: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
      }
    }
  }
}
