//
//  AppData.swift
//  APIConnectionExample
//
//  Version 0.0.1
//  Created by Roderic Linguri on 4/6/2017.
//  Copyright © 2017 Digices LLC. All rights reserved.
//  License: MIT. Modification permitted. This header must remain intact.
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
