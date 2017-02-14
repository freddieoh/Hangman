//
//  HangmanViewController.swift
//  Hangman
//
//  Created by Fredrick Ohen on 2/13/17.
//  Copyright © 2017 geeoku. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {
  
  let hangmanWord: String = ""
  let word: String = "Kappa"
  
  
  @IBOutlet weak var letterTextField: UITextField!
  @IBOutlet weak var incorrectGuessesLabel: UILabel!
  @IBOutlet weak var guessesRemainingLabel: UILabel!
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
        
    }
  
  func checkLetter() {
    
    if (hangmanWord.range(of: word) != nil) {
      print("Correct letter")
    } else {
      print("Guesses Remaining -1")
    }
  }
  
  
  @IBAction func guessButtonPressed(_ sender: Any) {
    
    checkLetter()
  }
  
}
