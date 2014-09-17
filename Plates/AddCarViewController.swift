//
//  AddCarViewController.swift
//  Plates
//
//  Created by Jason Humphries on 16/09/2557 BE.
//  Copyright (c) 2557 BE Jason Humphries. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class AddCarViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var yourMessageLabel: UILabel!
  @IBOutlet weak var plateField: UITextField!
  @IBOutlet weak var stateField: UITextField!
  @IBOutlet weak var colorField: UITextField!
  @IBOutlet weak var moodField: UITextField!
  @IBOutlet weak var messageTextView: UITextView!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var submitButtonBottomSpace: NSLayoutConstraint!
  @IBOutlet weak var scrollView: UIScrollView!
  
  let kBaseURL :String
  var carJSON: AnyObject
  var commentJSON: AnyObject
  var statusCode = -1
  let statePicker: UIPickerView
  let statesAbbreviationsArray: [String]
  let moodsArray: [String]
  let moodsPicker: UIPickerView
  var moodsInputAccessory: UIView
  var statesInputAccessory: UIView

  required init(coder aDecoder: NSCoder) {
    self.carJSON = NSDictionary()
    self.commentJSON = NSDictionary()
    self.statesInputAccessory = UIView()
    self.statePicker = UIPickerView()
    self.moodsInputAccessory = UIView()
    self.moodsPicker = UIPickerView()
    self.kBaseURL = "http://plates-rails.herokuapp.com"
    self.statesAbbreviationsArray = [ "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY", "DC" ]
    self.moodsArray = [ "THANK YOU!", "MEH", "HEY!", "$!@$ YOU", "NICE CAR", "YOU SUCK AT DRIVING!" ]
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.messageTextView.layer.borderColor = UIColor.darkGrayColor().CGColor
    self.messageTextView.layer.borderWidth = 1.0
    self.submitButtonBottomSpace.constant += 400
    
    self.statesInputAccessory = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
    self.statesInputAccessory.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.8)
    var doneButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    doneButton.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 62, 2, 60, 40)
    doneButton.setTitle("Done", forState: UIControlState.Normal)
    doneButton.backgroundColor = UIColor.whiteColor()
    doneButton.layer.cornerRadius = 4
    doneButton.clipsToBounds = true
    doneButton.addTarget(self, action: "dismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
    self.statesInputAccessory.addSubview(doneButton)
    
//    self.moodsPicker.dataSource = self
//    self.moodsPicker.delegate = self
//    self.moodsPicker.backgroundColor = UIColor.whiteColor()
    self.moodField.inputAccessoryView = self.statesInputAccessory
    self.moodField.inputView = self.moodsPicker
    
//    self.statePicker.dataSource = self
//    self.statePicker.delegate = self
//    self.statePicker.backgroundColor = UIColor.whiteColor()
    self.stateField.inputAccessoryView = self.statesInputAccessory
    self.stateField.inputView = self.statePicker
    
//    Alamofire.request(.GET, "http://redbutton.digitaldrasticstudios.com/v1/highscore/score")
//      .responseJSON { (request, response, JSON, error) -> Void in
//        self.printResponse(request, response: response, JSON: JSON, error: error)
//    };
  }
  
  func dismissKeyboard() {
    self.view.endEditing(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func cancelAction(sender: AnyObject) {
//    self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func sendAction(sender: AnyObject) {
    var params: Dictionary<String, String> = ["plate":plateField.text]
    createCar(params)
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
    if pickerView.isEqual(self.statePicker) {
      return self.statesAbbreviationsArray.count
    } else if pickerView.isEqual(self.moodsPicker) {
      return self.moodsArray.count
    } else {
      return 0
    }
  }
  
  func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
    if pickerView.isEqual(self.statePicker) {
      return self.statesAbbreviationsArray[row]
    } else if pickerView.isEqual(self.moodsPicker) {
      return self.moodsArray[row]
    } else {
      return ""
    }
  }
  
  func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
    if pickerView.isEqual(self.statePicker) {
      self.stateField.text = self.statesAbbreviationsArray[row]
    } else if pickerView.isEqual(self.moodsPicker) {
      self.moodField.text = self.moodsArray[row]
    }
  }
  
  func textFieldShouldReturn(textField: UITextField!) -> Bool {
    if textField.isEqual(plateField) {
      var params :Dictionary<String, String> = ["plate":plateField.text]
      createCar(params)
    }
    return true
  }
  
  func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
    if textField.isEqual(self.moodField) {
      // mood
    } else if textField.isEqual(self.stateField) {
      // state
    } else if textField.isEqual(self.plateField) {
      // plate
    }
    return true
  }
  
  ///////////////
  // API METHODS
  ///////////////
  
  func createCar(carDict: Dictionary <String, String>) {
    let urlPath: String = "\(kBaseURL)/cars"
    Alamofire.request(Alamofire.Method.POST, urlPath, parameters: ["car": carDict])
      .responseJSON { (request, response, JSON, error) -> Void in
        self.printResponse(request, response: response, JSON: JSON, error: error)
        if JSON != nil {
          self.carJSON = JSON!;
          if self.carJSON.objectForKey("id") != nil {
            var carId: NSNumber = self.carJSON.objectForKey("id") as NSNumber
            var params = ["message": "????"] as Dictionary
            self.createComment(params, carID: carId)
          }
        }
    };
  }
  
  // COMMENT CREATION
  func createComment(commentDict: NSDictionary, carID: NSNumber) {
    let urlPath :String = "\(kBaseURL)/leave_comment/\(carID)"
    Alamofire.request(Alamofire.Method.POST, urlPath, parameters: ["comment": commentDict])
      .responseJSON { (request, response, JSON, error) in
        if JSON != nil {
          self.commentJSON = JSON!
        }
        self.printResponse(request, response: response, JSON: JSON, error: error)
    }
  }

  
  func printResponse(request: NSURLRequest, response: NSHTTPURLResponse?, JSON: AnyObject?, error: NSError?) {
    println("REQUEST: \(request)")
    println("RESPONSE: \(response)")
    println("JSON: \(JSON)")
    println("ERROR: \(error)")
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == "newCarSegue" {
      var startingPlateName: String? = sender as String?
      self.plateField.text = startingPlateName
    }
  }
  
}
