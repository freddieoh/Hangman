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
  var numberOfIncorrectGuesses: Int = 0
  var guessesRemaining: Int = 6
  var correctHangmanWord = ""
  let userGuessLength: Int = 1
  var correctLetters = [String]()
  var incorrectLetters = [String]()
  
  @IBOutlet weak var letterTextField: UITextField!
  @IBOutlet weak var incorrectGuessesLabel: UILabel!
  @IBOutlet weak var guessesRemainingLabel: UILabel!
  @IBOutlet weak var hangmanWordLabel: UILabel!
  @IBOutlet weak var userWonLabel: UILabel!
  @IBOutlet weak var userLostLabel: UILabel!
  @IBOutlet weak var guessEntireWordTextField: UITextField!
  @IBOutlet weak var incorrectGuessedLettersLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getWordsFromApi()
    letterTextField.delegate = self
    userWonLabel.isHidden = true
    userLostLabel.isHidden = true
    
  }
  
  func getWordsFromApi() {
    let urlString = "http://linkedin-reach.hagbpyjegb.us-west-2.elasticbeanstalk.com/words"
    let urlRequest = URL(string: urlString)
    URLSession.shared.dataTask(with: urlRequest!) { (data, response, error) in
      if error != nil {
        print(error.debugDescription)
      } else {
        let dataString = String(data: data!, encoding: .utf8)
        self.linkedInWords = (dataString?.components(separatedBy: CharacterSet.newlines))!
        self.correctHangmanWord = self.getRandomWord()
        self.hangmanWordLabel.text = self.displayDashesForWord()
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
  
  func updateNumberOfGuesses() {
    if numberOfIncorrectGuesses < 6 || guessesRemaining > 1 {
      numberOfIncorrectGuesses += 1
      guessesRemaining -= 1
    }
    userUsedAllGuesses()
  }
  
  func resetNumberOfGuesses() {
    numberOfIncorrectGuesses = -1
    guessesRemaining = 7
    updateGuessesLabels()
  }
  
  func updateGuessesLabels() {
    updateNumberOfGuesses()
    self.guessesRemainingLabel.text = "\(guessesRemaining)"
    self.incorrectGuessesLabel.text = "\(numberOfIncorrectGuesses)"
    print("Match not found")
  }
  
  func userUsedAllGuesses() {
    if numberOfIncorrectGuesses == 6, guessesRemaining == 0 {
      revealHangmanWord()
    }
  }
  
  func userWon() {
    userWonLabel.isHidden = false
  }
  
  func checkUserLetter() {
    var userGuess = self.letterTextField.text
    let userCorrectLetters = correctLetters
    print(userCorrectLetters)
    print(correctHangmanWord)
    
    // Put the string from guessedAnswerLabel.text
    let exampleDisplayAnswer = self.hangmanWordLabel.text
    if correctHangmanWord.contains(userGuess!) {
      correctLetters.append(userGuess!)
      print("Match Found")
      
      // Turn answer into an array of characters
      let answerArray = Array(correctHangmanWord.characters)
      var extraArray = Array(exampleDisplayAnswer!.characters)
      
      // run the for loop that checks their character guess against each character in your answer, and saves the index of their guess into the correct letters array
      for char in 0...answerArray.count-1 {
        let newCharacter = String(answerArray[char])
        if userGuess == newCharacter {
          extraArray.remove(at: char)
          extraArray.insert(userGuess!.characters.first!, at: char)
        }
      }
      // Turns extraArray into a string and put into guessedAnswerLabel
      let newString = extraArray.map({"\($0)"}).joined(separator: "")
      self.hangmanWordLabel.text = newString
    } else {
      updateGuessesLabels()
      self.incorrectLetters.append(userGuess!)
      self.incorrectGuessedLettersLabel.text = self.incorrectLetters.joined(separator: ",")
    }
    let correctLettersArray = userCorrectLetters.joined(separator: "")
    print(correctLettersArray)
    if correctLettersArray == "\(correctHangmanWord.characters)" {
      userWon()
    }
  }
  
  func userLost() {
    userLostLabel.isHidden = false
  }
  
  func getRandomWord() -> String {
    let randomNumber = generateRandomNumber(number: UInt32(self.linkedInWords.count))
    return self.linkedInWords[randomNumber]
  }
  
  func generateRandomNumber(number: UInt32) -> Int {
    return Int(arc4random_uniform(number))
  }
  
  func revealHangmanWord() {
    self.hangmanWordLabel.text = "\(self.correctHangmanWord)"
    userLost()
  }
  
  func checkEntireGuessedWord() {
    if guessEntireWordTextField.text == correctHangmanWord {
      userWon()
    } else {
      userLost()
    }
  }
  
  func playGame() {
    self.correctHangmanWord = self.getRandomWord()
    self.hangmanWordLabel.text = self.displayDashesForWord()
  }
  
  @IBAction func getNewWordButtonPressed(_ sender: Any) {
    self.correctHangmanWord = self.getRandomWord()
    self.hangmanWordLabel.text = self.displayDashesForWord()
    resetNumberOfGuesses()
    userWonLabel.isHidden = true
    userLostLabel.isHidden = true
  }
  
  @IBAction func guessEntireWordButtonPressed(_ sender: Any) {
    checkEntireGuessedWord()
  }
  
  @IBAction func guessButtonPressed(_ sender: Any) {
    checkUserLetter()
  }
  
  @IBAction func revealButtonPressed() {
    revealHangmanWord()
  }
}

// MARK: UITextFieldDelegate
extension HangmanViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = letterTextField.text else { return true }
    let newLength = text.characters.count + string.characters.count - range.length
    return newLength <= userGuessLength
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    checkUserLetter()
    print("User hit return")
    return true
  }
}
