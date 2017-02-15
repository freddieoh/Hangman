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
  var numberOfGuesses: Int = 0
  var guessesRemaining: Int = 6
  
  var answer = "Test"
  
  
  @IBOutlet weak var letterTextField: UITextField!
  @IBOutlet weak var incorrectGuessesLabel: UILabel!
  @IBOutlet weak var guessesRemainingLabel: UILabel!
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
      getWordsFromApi()
  }
  
  func updateGuesses() {
    if numberOfGuesses < 6 || guessesRemaining > 5 {
      numberOfGuesses += 1
      guessesRemaining -= 1
    }
  }

  func getWordsFromApi() {
    let url:String = "http://linkedin-reach.hagbpyjegb.us-west-2.elasticbeanstalk.com/words"
    let urlRequest = URL(string: url)
    URLSession.shared.dataTask(with: urlRequest!) { (data, response, error) in
      if error != nil {
        print(error.debugDescription)
      } else {
        let dataString = String(data: data!, encoding: .utf8)
        self.linkedInWords = (dataString?.components(separatedBy: CharacterSet.newlines))!
        }
      } .resume()
  }
  
  @IBAction func guessButtonPressed(_ sender: Any) {
    
    let userGuess = self.letterTextField?.text
   // let searchChar: Character = "C"
    
    var counter = 0
    
    for char in answer.characters {
      
      counter += 1
      
      let characterToString = "\(char)"

      if userGuess! == characterToString {
          print("Match found")
        } else {
        if counter == answer.characters.count {
          
          updateGuesses()
          self.guessesRemainingLabel.text = "\(guessesRemaining)"
          self.incorrectGuessesLabel.text = "\(numberOfGuesses)"
          print("Match not found")
        }
        }
      }
    }
  }

