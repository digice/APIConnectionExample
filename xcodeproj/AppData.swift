//
//  AppData.swift
//  BeaconSpike
//
//  Created by Digices LLC on 4/1/17.
//  Copyright © 2017 Digices LLC. All rights reserved.
//

import Foundation

class AppData : NSObject, NSCoding {

  // MARK: - Properties

  let test : TestData

  // MARK: - NSObject Methods

  override init() {
    self.test = TestData()
  }

  // MARK: - NSCoding Methods

  required init?(coder aDecoder: NSCoder) {
    self.test = aDecoder.decodeObject(forKey: "test") as! TestData
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.test, forKey: "test")
  }

}
