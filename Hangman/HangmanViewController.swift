//
//  HangmanViewController.swift
//  Hangman
//
//  Created by Fredrick Ohen on 2/13/17.
//  Copyright © 2017 geeoku. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {
  
  var linkedInWords = [String]()
  
  @IBOutlet weak var letterTextField: UITextField!
  @IBOutlet weak var incorrectGuessesLabel: UILabel!
  @IBOutlet weak var guessesRemainingLabel: UILabel!
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    let url:String = "http://linkedin-reach.hagbpyjegb.us-west-2.elasticbeanstalk.com/words"
    let urlRequest = URL(string: url)
    URLSession.shared.dataTask(with: urlRequest!) { (data, response, error) in
      if error != nil {
        print(error.debugDescription)
      } else {
        let dataString = String(data: data!, encoding: .utf8)
        
        self.linkedInWords = (dataString?.components(separatedBy: CharacterSet.newlines))!
        
        print(dataString!)
      }
      
      } .resume()
    
  }
  
  @IBAction func guessButtonPressed(_ sender: Any) {
    
  }
}
