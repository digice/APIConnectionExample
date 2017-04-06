//
//  TestDataManager.swift
//  APIConnectionExample
//
//  Version 0.0.1
//  Created by Roderic Linguri on 4/6/2017.
//  Copyright © 2017 Digices LLC. All rights reserved.
//  License: MIT. Modification permitted. This header must remain intact.
//

import Foundation

protocol TestDataManagerDelegate {
  func testDataManagerDidUpdateData()
}

class TestDataManager : ConnectionManagerDelegate {

  // MARK: - Properties

  // we don't keep our own copy of the data...
  var data : TestData = AppDataManager.shared.data.test

  var manager : ConnectionManager = ConnectionManager()

  var delegate : TestDataManagerDelegate?

  var message : String = ""

  // MARK: - TestDataManager Methods

  init() {
    self.manager.delegate = self
  } // ./init

  func sendCreateRequest() {

    // api expects: 'm=test&a=create&n=MyUsername&p=MyMassword&e=me@mydomain.com'
    
    var body = "m=test&a=create"

    if let n = self.data.name {
      body.append("&n=\(n)")
    }

    if let p = self.data.password {
      body.append("&p=\(p)")
    }

    if let e = self.data.email {
      body.append("&e=\(e)")
    }

    self.manager.setRequestBody(httpBody: body)

    self.manager.sendRequest()

  } // ./sendCreateRequest

  func sendLoginRequest() {

    // api expects: 'm=test&a=authenticate&n=MyUsername&p=MyMassword'
    
    var body = "m=test&a=authenticate"

    if let n = self.data.name {
      body.append("&n=\(n)")
    }

    if let p = self.data.password {
      body.append("&p=\(p)")
    }

    self.manager.setRequestBody(httpBody: body)

    self.manager.sendRequest()

  } // ./sendLoginRequest

  func sendUpdateRequest() {

    var body = "m=test&a=update"

    if let t = self.data.token {
      body.append("&t=\(t)")
    }

    if let n = self.data.name {
      body.append("&n=\(n)")
    }

    if let p = self.data.password {
      body.append("&p=\(p)")
    }

    if let e = self.data.email {
      body.append("&e=\(e)")
    }

    self.manager.setRequestBody(httpBody: body)

    self.manager.sendRequest()

  } // ./sendUpdateRequest

  func logOut() {

    // http request is simply a coutesy to the api

    var body = "m=test&a=logout"

    if let i = self.data.id {
      body.append("&i=\(i)")
    }

    if let t = self.data.token {
      body.append("&t=\(t)")
    }

    self.manager.setRequestBody(httpBody: body)

    self.manager.sendRequest()

    // we will not wait for a response to de-authenticate in app

    self.data.authenticated = false
    self.data.token = nil
    self.data.password = nil

    self.save()

  } // ./logOut

  func save() {
    AppDataManager.shared.save()
  } // ./save

  // MARK: - ConnectionManagerDelegate Methods

  func connectionManagerDidReceiveResponse(message: String) {

    self.message = message

    if self.manager.state == .responseParsed {

      if self.manager.success == true {

        // we only update data when success is true

        if self.manager.action == "create" {
          self.data.created = true
        } else if self.manager.action == "authenticate" {
          self.data.authenticated = true
        } else if self.manager.action == "logout" {
          self.data.authenticated = false
          self.data.token = nil
          self.data.password = nil
        }

        // extract int from Any?
        if let i = self.manager.response["id"] {
          let tryString = i as? String
          if let idString = tryString {
            let tryInt = Int(idString)
            if let idInt = tryInt {
              self.data.id = idInt
            }
          }
        }

        if let t = self.manager.response["token"] {
          self.data.token = t as? String
        }

        self.save()

      } // ./success is true

    } // response was parsed

    if let d = self.delegate {
      d.testDataManagerDidUpdateData()
    } // ./delegate is set

  } // ./connectionManagerDidReceiveResponse

}
