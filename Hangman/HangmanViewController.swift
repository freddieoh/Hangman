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
  var correctHangmanWord = ""
  let userGuessLength: Int = 1
  
  
  @IBOutlet weak var letterTextField: UITextField!
  @IBOutlet weak var incorrectGuessesLabel: UILabel!
  @IBOutlet weak var guessesRemainingLabel: UILabel!
  @IBOutlet weak var hangmanWordLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getWordsFromApi()
    letterTextField.delegate = self
    
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
        self.correctHangmanWord = self.getRandomWord()
        self.hangmanWordLabel.text = "\(self.displayDashesForWord())"
        
      }
      } .resume()
  }
  
  func displayDashesForWord() -> String {
    var dashes = ""
    for _ in 0..<self.correctHangmanWord.characters.count {
      dashes += "-"
    }
    return dashes
  }
  
  
  func testLabel() {
    self.hangmanWordLabel.text = self.displayDashesForWord()
  }
  
  func updateNumberOfGuesses() {
    if numberOfGuesses < 6 || guessesRemaining > 1 {
      numberOfGuesses += 1
      guessesRemaining -= 1
    }
  }
  
  func updateGuessesLabels() {
    updateNumberOfGuesses()
    self.guessesRemainingLabel.text = "\(guessesRemaining)"
    self.incorrectGuessesLabel.text = "\(numberOfGuesses)"
    print("Match not found")
    
    // Image of Hangman body part appears
    
  }
  

  func checkUserLetter() {
    let userGuess = self.letterTextField.text
    var correctLetters = [Int]()
    let exampleDisplayAnswer = self.hangmanWordLabel.text //put the string from alreadyGuessedAnswerLabel.text
    
    if correctHangmanWord.contains(userGuess!) {
      print("Match Found")
      
      let answerArray = Array(correctHangmanWord.characters) //turn your answer into an array of characters
      var extraArray = Array(exampleDisplayAnswer!.characters)
      
      // run the for loop that checks their character guess against each character in your answer, and saves the index of their guess into the correct letters array
      for char in 0...answerArray.count-1 {
        let newCharacter = String(answerArray[char])
        if userGuess == newCharacter {
          correctLetters.append(char)
          extraArray.remove(at: char)
          extraArray.insert(userGuess!.characters.first!, at: char)
        }
      }
      //turn extraArray into a string and put into the guessedAnswerLabel
      let newString = extraArray.map({"\($0)"}).joined(separator: "")
      self.hangmanWordLabel.text = newString
    } else {
      updateGuessesLabels()
    }
  }
  
  func getRandomWord() -> String {
    let randomNumber = generateRandomNumber()
    return self.linkedInWords[randomNumber]
  }
  
  func generateRandomNumber() -> Int {
    return Int(arc4random_uniform(UInt32(self.linkedInWords.count)))
  }
  
  func revealHangmanWord() {
    self.hangmanWordLabel.text = "\(self.correctHangmanWord)"
  }
  
  @IBAction func getNewWordButtonPressed(_ sender: Any) {
    
      self.hangmanWordLabel.text = self.getRandomWord()
  }

  @IBAction func guessButtonPressed(_ sender: Any) {
    checkUserLetter()
  }

  @IBAction func revealButtonPressed() {
    revealHangmanWord()
    
  }
}

extension HangmanViewController: UITextFieldDelegate {

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = letterTextField.text else { return true }
    let newLength = text.characters.count + string.characters.count - range.length
    return newLength <= userGuessLength
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    print("User hit return")
    return true
  }
  
}
