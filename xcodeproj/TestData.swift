//
//  TestData.swift
//  APIConnection
//
//  Created by Digices LLC on 4/5/17.
//  Copyright © 2017 Digices LLC. All rights reserved.
//

import Foundation

class TestData : NSObject, NSCoding {

  // MARK: - Properties

  var id : Int?

  var name : String?

  var password : String?

  var email : String?

  var token : String?

  var created : Bool = false

  var authenticated : Bool = false

  // MARK: - NSObject Methods

  override init() {

    super.init()

  } // ./init

  // MARK: - NSCoding Methods

  required init?(coder aDecoder: NSCoder) {

    // conditionally set optional properties based on recognizably invalid values

    let i = aDecoder.decodeInteger(forKey: "id")
    if i != 0 {
      self.id = i
    }

    let n = aDecoder.decodeObject(forKey: "name") as! String
    if n != "nil" {
      self.name = n
    }

    let p = aDecoder.decodeObject(forKey: "password") as! String
    if p != "nil" {
      self.password = p
    }

    let e = aDecoder.decodeObject(forKey: "email") as! String
    if e != "nil" {
      self.email = e
    }

    let t = aDecoder.decodeObject(forKey: "token") as! String
    if t != "nil" {
      self.token = t
    }

    // non-optional properties must have a value

    self.created = aDecoder.decodeBool(forKey: "created")

    self.authenticated = aDecoder.decodeBool(forKey: "authenticated")

  } // ./initWithCoder

  func encode(with aCoder: NSCoder) {

    if let i = self.id {
      aCoder.encode(i, forKey: "id")
    } else {
      aCoder.encode(0, forKey: "id")
    }

    if let n = self.name {
      aCoder.encode(n, forKey: "name")
    } else {
      aCoder.encode("nil", forKey: "name")
    }

    if let p = self.password {
      aCoder.encode(p, forKey: "password")
    } else {
      aCoder.encode("nil", forKey: "password")
    }

    if let e = self.email {
      aCoder.encode(e, forKey: "email")
    } else {
      aCoder.encode("nil", forKey: "email")
    }

    if let t = self.token {
      aCoder.encode(t, forKey: "token")
    } else {
      aCoder.encode("nil", forKey: "token")
    }

    aCoder.encode(self.created, forKey: "created")

    aCoder.encode(self.authenticated, forKey: "authenticated")

  } // ./encode



}
