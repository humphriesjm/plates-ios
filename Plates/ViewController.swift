//
//  ViewController.swift
//  Plates
//
//  Created by Jason Humphries on 16/09/2557 BE.
//  Copyright (c) 2557 BE Jason Humphries. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    Alamofire.request(.GET, "http://redbutton.digitaldrasticstudios.com/v1/highscore/score")
      .responseJSON { (request, response, JSON, error) -> Void in
        println("REQUEST: \(request)")
        println("RESPONSE: \(response)")
        println("JSON: \(JSON)")
        println("ERROR: \(error)")
    };
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }


}

