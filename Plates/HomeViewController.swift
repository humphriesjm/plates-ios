//
//  HomeViewController.swift
//  Plates
//
//  Created by Jason Humphries on 17/09/2557 BE.
//  Copyright (c) 2557 BE Jason Humphries. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {

  @IBOutlet weak var searchField: UITextField!
  @IBOutlet weak var table: UITableView!
  @IBOutlet var hitServerButton: UIButton?
  
  let kBaseURL = "http://plates-rails.herokuapp.com"
  var statusCode = -1
  var platesArray :Array<Dictionary<String, String>> = Array.init()
  var commentsArray :Array<String> = Array.init()
  var carData = NSData()
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func textFieldShouldReturn(textField: UITextField!) -> Bool {
    textField.resignFirstResponder()
    searchPlate(textField.text)
    return true
  }
  
  func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
    if (textField.isEqual(self.searchField)) {
      var fieldText: String = textField.text.uppercaseString
      var newText: String = string
      var inputText = fieldText + newText
//      var fieldText: String = self.searchField.text.uppercaseString
//      var newText: String = string
//      let nsRange: NSRange = range as NSRange
//      var inputText: String = (fieldText as NSString).stringByReplacingCharactersInRange(nsRange, withString: newText) as String
//      textField.text = inputText
      if countElements(inputText) > 0 {
        searchPlate(inputText)
      }
    }
    return true
  }
  
  func tableView(tableView:UITableView!, numberOfRowsInSection section:Int)->Int {
    return self.platesArray.count + 1
  }
  
  func numberOfSectionsInTableView(tableView:UITableView!)->Int {
    return 1
  }
  
  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    if (indexPath.row == 0) {
      cell.textLabel?.text = "+ Add Plate"
      cell.textLabel?.textAlignment = NSTextAlignment.Center
      return cell
    }
    var thisCarDict :Dictionary<String, String> = platesArray[indexPath.row-1]
    cell.textLabel?.text = thisCarDict["plate"]
    return cell
  }
  
  func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    if (indexPath.row - 1) < 0 {
      // first cell
      self.performSegueWithIdentifier("newCarSegue", sender: self.searchField.text as String)
      return
    } else {
      var thisCarDict :Dictionary<String, String> = platesArray[indexPath.row-1]
      println("thisCarDict: \(thisCarDict)")
      var inputNumber: String? = thisCarDict["id"]
      if inputNumber != nil {
        searchComment(inputNumber!)
      }
      return
    }
  }
  
  // PLATE SEARCH
  func searchPlate(searchTerm :NSString) {
    let urlPath: String = "\(kBaseURL)/search_plates/\(searchTerm)"
    Alamofire.request(Alamofire.Method.GET, urlPath, parameters: nil)
    .responseJSON { (request, response, JSON, error) -> Void in
      if JSON != nil {
        self.platesArray = JSON as Array
      }
      self.table.reloadData()
    }

    Alamofire.request(.GET, urlPath)
      .responseJSON { (request, response, JSON, error) in
        if JSON != nil {
          self.platesArray = JSON as Array
        }
        self.table.reloadData()
    }
//    var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(JSON, options: NSJSONReadingOptions.MutableLeaves, error: &error)
  }
  
  // COMMENT SEARCH
  func searchComment(carID :String) {
    let urlPath: String = "\(kBaseURL)/get_comments/\(carID)"
    
    Alamofire.request(Alamofire.Method.GET, urlPath, parameters: nil)
      .responseJSON { (request, response, JSON, error) in
        if JSON != nil {
          self.commentsArray = JSON as Array
        }
        self.table.reloadData()
    }
//    var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &err)
  }

}
