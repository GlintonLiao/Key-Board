//
//  InterfaceVariables.swift
//
//  Variables associated with the base keyboard interface.
//
//  Created by Guotong Liao
//

import UIKit

// A proxy into which text is typed.
var proxy: UITextDocumentProxy!

// MARK: Display Variables

// Variables for the keyboard and its appearance.
var keyboard: [[String]] = [[String]]()
let specialKeys = [
  "shift", "delete", "selectKeyboard", "space", "return", "tab"
]
var allNonSpecialKeys: [String] = [String]()
var keyboardHeight: CGFloat!
var keyCornerRadius: CGFloat!
var commandKeyCornerRadius: CGFloat!
var keyWidth = CGFloat(0)
var letterKeyWidth = CGFloat(0)
var commandKeyWidth = CGFloat(0)
var keyboardLoad = false
var needsInputSwitch = false

// Arrays for the possible keyboard views that are loaded with their characters.
var letterKeys: [[String]] = [[String]]()
var numberKeys: [[String]] = [[String]]()
var commandKeys: [[String]] = [[String]]()

/// States of the keyboard corresponding to layouts found in KeyboardConstants.swift.
enum KeyboardState {
  case letters
}

/// What the keyboard state is in regards to the shift key.
/// - normal: not capitalized
/// - shift: capitalized
/// - caps: caps-lock
enum ShiftButtonState {
  case normal
  case shift
  case caps
}

/// States of the keyboard corresponding to which commands the user is executing.
enum CommandState {
  case idle
  case colon
  case leftPa
  case rightPa
  case line
}

// Baseline state variables.
var keyboardState: KeyboardState = .letters
var shiftButtonState: ShiftButtonState = .normal
var commandState: CommandState = .idle

// Variables and functions to determine display parameters.
struct DeviceType {
  static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
}

var isLandscapeView: Bool = false

/// Checks if the device is in landscape mode.
func checkLandscapeMode() {
  if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
    isLandscapeView = true
  } else {
    isLandscapeView = false
  }
}

// MARK: English Interface Variables
// Note: here only until there is an English keyboard.

public enum EnglishKeyboardConstants {
  // Keyboard key layouts.
  static let lettersKeys = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", ":"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", ";"],
    ["selectKeyboard", "tab", ",", "space", ".", "return"]
  ]
  
  static let commandKeys = [
    ["C++"], ["| \"", "\\ '"], ["< {", "( ["], ["> }", ") ]"], ["_ +", "- ="], ["delete"],
  ]
  
  static let numbersAndSymbols = [
    ["!", "1"], ["@", "2"], ["#", "3"], ["$", "4"], ["%", "5"], ["^", "6"], ["&", "7"], ["*", "8"], ["(", "9"], [")", "0"]
  ]
}

let keySet0 = ["", "|", "\\", "\"", "'"]
let keySet1 = ["", "<", "(", "{", "["]
let keySet2 = ["", ">", ")", "}", "]"]
let keySet3 = ["", "_", "-", "+", "="]
let baseKeySet = ["", "colon", "leftPa", "rightPa", "line"]
