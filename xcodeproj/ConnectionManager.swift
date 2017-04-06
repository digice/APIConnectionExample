//
//  ConnectionManager.swift
//  APIConnectionExample
//
//  Version 0.0.1
//  Created by Roderic Linguri on 4/6/2017.
//  Copyright © 2017 Digices LLC. All rights reserved.
//  License: MIT. Modification permitted. This header must remain intact.
//

import UIKit

enum ConnectionState {
  case invalid
  case urlSet
  case httpMethodSet
  case httpBodySet
  case requestSent
  case responseReceived
  case errorInResponse
  case dataInResponse
  case noDataInResponse
  case errorParsingData
  case responseParsed
}

protocol ConnectionManagerDelegate {
  func connectionManagerDidReceiveResponse(message: String)
}

class ConnectionManager {

  // MARK: - Properties

  var request : URLRequest = URLRequest(url: URL(string: "https://<#api-bootstrapper-url#>")!)

  var state : ConnectionState = .urlSet

  var response : [String : Any] = [:]

  var delegate : ConnectionManagerDelegate?

  var model : String?

  var action : String?

  var success : Bool = false

  // MARK: - ConnectionManager (self) Methods

  func setRequestBody(httpBody: String) {

    self.request.httpMethod = "POST"
    self.state = .httpMethodSet

    self.request.httpBody = httpBody.data(using: .utf8)
    self.state = .httpBodySet

  } // ./setRequest

  func parseResponse(data: Data) -> Bool {

    self.response = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]

    if self.response.count > 0 {
      self.state = .responseParsed
      return true
    } else {
      self.state = .errorParsingData
      return false
    }

  } // ./parseResponse

  func completionHandler(data: Data?, response: URLResponse?, error: Error?) {

    self.state = .responseReceived

    if error != nil {
      self.state = .errorInResponse
    }

    // initialize string to send to our delegate
    var message : String = ""

    // attempt to unwrap data
    if let d = data {

      // DEBUG: Print Response To Console
      if let str = String(data: d, encoding: .utf8) {
        print("Received Data:")
        print(str)
      }

      self.state = .dataInResponse

      if self.parseResponse(data: d) == true {

        // check for model
        if let m = self.response["model"] as? String {
          self.model = m
        }

        // check for action
        if let a = self.response["action"] as? String {
          self.action = a
        }

        // check for success
        if let s = self.response["success"] as? String {
          if s == "true" {
            self.success = true
          } else {
            self.success = false
          }
        }

        // check for message
        if let g = self.response["message"] as? String {
          message = g
        } // ./message was present in response

        else {
          // self.state = .responseParsed
          message = "A Response was parsed"
        } // ./no message in response


      } // ./json was parsed

      else {
        // self.state = .errorParsingData
        message = "There was an error parsing the response."
      } // ./json not parsed

    } // ./data was received

    else {
      self.state = .noDataInResponse
      message = "There was no data in the response"
    } // ./no data

    if let g = self.delegate {

      OperationQueue.main.addOperation {

        // notify delegate
        g.connectionManagerDidReceiveResponse(message: message)

        // turn off spinner
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

      } // ./added operation to main queue

    } // ./delegate is set

  } // ./completionHandler

  func sendRequest() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    let session = URLSession.shared
    let task = session.dataTask(with: self.request, completionHandler: self.completionHandler)
    task.resume()
    self.state = .requestSent
  } // ./sendRequest

}
