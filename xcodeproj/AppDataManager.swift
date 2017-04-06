//
//  AppManager.swift
//  APIConnectionExample
//
//  Version 0.0.1
//  Created by Roderic Linguri on 4/6/2017.
//  Copyright © 2017 Digices LLC. All rights reserved.
//  License: MIT. Modification permitted. This header must remain intact.
//

import Foundation

protocol AppDataManagerDelegate {
  func appManagerdidSaveData()
}

class AppDataManager
{

  // MARK: - Properties

  static let shared : AppDataManager = AppDataManager()

  var delegate : AppDataManagerDelegate?

  var data : AppData

  // MARK: - Methods

  private init() {

    // attempt to load data from UserDefaulys
    if let storedData = UserDefaults.standard.object(forKey: "data") as? Data {

      // yes, we have data
      self.data = (NSKeyedUnarchiver.unarchiveObject(with: storedData) as? AppData)!

    } else {

      // no data, create a default object and save it
      self.data = AppData()
      self.save()

    }

  }

  // save data to UserDefaults
  func save() {

    let ud = UserDefaults.standard
    let dataToSave = NSKeyedArchiver.archivedData(withRootObject: self.data)
    ud.set(dataToSave, forKey: "data")
    ud.synchronize()

    // notify our delegate if we have one
    if let d = self.delegate {
      d.appManagerdidSaveData()
    }

  }

}
