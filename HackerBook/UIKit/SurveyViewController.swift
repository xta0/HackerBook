/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit
class SurveyViewController: UIViewController {
  let nameTextField = UITextField()
  let emailTextField = UITextField()
  let phoneNumberTextField = UITextField()
  let countryTextField = UITextField()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Survey"
    view.backgroundColor = .white
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonTapped))
    configureTextField(textField: nameTextField, placeholder: "Name")
    configureTextField(textField: emailTextField, placeholder: "Email")
    configureTextField(textField: phoneNumberTextField, placeholder: "Phone Number")
    configureTextField(textField: countryTextField, placeholder: "Country")

    nameTextField.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40)
    emailTextField.frame = CGRect(x: 20, y: 160, width: view.frame.width - 40, height: 40)
    phoneNumberTextField.frame = CGRect(x: 20, y: 220, width: view.frame.width - 40, height: 40)
    countryTextField.frame = CGRect(x: 20, y: 280, width: view.frame.width - 40, height: 40)

    view.addSubview(nameTextField)
    view.addSubview(emailTextField)
    view.addSubview(phoneNumberTextField)
    view.addSubview(countryTextField)
  }

  @objc func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }

  private func configureTextField(textField: UITextField, placeholder: String) {
    textField.placeholder = placeholder
    textField.borderStyle = .roundedRect
  }
}
