//
//  ViewController.swift
//  APIConnection
//
//  Created by Digices LLC on 4/5/17.
//  Copyright © 2017 Digices LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TestDataManagerDelegate {

  // MARK: - Outlets

  @IBOutlet weak var typeControl: UISegmentedControl!

  @IBOutlet weak var idLabel: UILabel!

  @IBOutlet weak var idField: UITextField!

  @IBOutlet weak var nameField: UITextField!

  @IBOutlet weak var passwordField: UITextField!

  @IBOutlet weak var tokenLabel: UILabel!

  @IBOutlet weak var emailField: UITextField!

  @IBOutlet weak var tokenField: UITextField!

  @IBOutlet weak var sendRequestButton: UIButton!

  @IBOutlet weak var messageLabel: UILabel!

  // MARK: - Properties

  let manager : TestDataManager = TestDataManager()


  // MARK: - UIViewController Methods

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard)))
    self.manager.delegate = self
    self.updateViewFromData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - TestDataManagerDelegate

  func testDataManagerDidUpdateData() {
    self.updateViewFromData()
  }

  // MARK: - ViewController (self) Methods

  func updateViewFromData() {

    // handles updating user interface from stored data

    // check authentication status
    if self.manager.data.authenticated == true {
      self.typeControl.selectedSegmentIndex = 2
    } else if self.manager.data.created == true {
      self.typeControl.selectedSegmentIndex = 1
    } else {
      self.typeControl.selectedSegmentIndex = 0
    }

    self.didChangeType(self)

    if let i = self.manager.data.id {
      self.idField.text = "\(i)"
    }

    if let n = self.manager.data.name {
      self.nameField.text = n
    }

    if let p = self.manager.data.password {
      self.passwordField.text = p
    }

    if let e = self.manager.data.email {
      self.emailField.text = e
    }

    if let t = self.manager.data.token {
      self.tokenField.text = t
    }

    self.messageLabel.text = self.manager.message

  }

  func updateDataFromView() {

    // id and token are sourced by API, so we do not update these

    if let n = self.nameField.text {
      if n.characters.count > 0 {
        self.manager.data.name = n
      }
    }

    if let p = self.passwordField.text {
      if p.characters.count > 0 {
        self.manager.data.password = p
      }
    }

    if let e = self.emailField.text {
      if e.characters.count > 0 {
        self.manager.data.email = e
      }
    }

    self.manager.save()

  }

  func dismissKeyboard()
  {
    self.view.endEditing(true)
  }

  // MARK: - Actions

  @IBAction func didChangeType(_ sender: Any) {

    if self.typeControl.selectedSegmentIndex == 0 {
      self.idField.isHidden = true
      self.idLabel.isHidden = true
      self.tokenField.isHidden = true
      self.tokenLabel.isHidden = true
      self.sendRequestButton.setTitle("Create Account", for: .normal)
    } else if self.typeControl.selectedSegmentIndex == 1 {
      self.idField.isHidden = true
      self.idLabel.isHidden = true
      self.tokenField.isHidden = true
      self.tokenLabel.isHidden = true
      self.sendRequestButton.setTitle("Log In", for: .normal)
    } else if self.typeControl.selectedSegmentIndex == 2 {
      self.idField.isHidden = false
      self.idLabel.isHidden = false
      self.tokenField.isHidden = false
      self.tokenLabel.isHidden = false
      self.sendRequestButton.setTitle("Update Info", for: .normal)
    } else {
      self.idField.isHidden = false
      self.tokenField.isHidden = false
      self.sendRequestButton.setTitle("Log Out", for: .normal)
    }

  }

  @IBAction func sendRequest(_ sender: Any) {

    // update data from view
    self.updateDataFromView()

    if self.typeControl.selectedSegmentIndex == 0 {
      self.manager.sendCreateRequest()
    } else if self.typeControl.selectedSegmentIndex == 1 {
      self.manager.sendLoginRequest()
    } else if self.typeControl.selectedSegmentIndex == 2 {
      self.manager.sendUpdateRequest()
    } else {
      self.manager.logOut()
    }

  }

}

