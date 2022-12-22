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
var allKeys: [String] = [String]()
let specialKeys = [
  "shift", "delete", "selectKeyboard", "space", "return", "tab", "hideKeyboard"
]
var allNonSpecialKeys: [String] = [String]()
var keyboardHeight: CGFloat!
var keyCornerRadius: CGFloat!
var commandKeyCornerRadius: CGFloat!
var keyWidth = CGFloat(0)
var letterKeyWidth = CGFloat(0)
var numSymKeyWidth = CGFloat(0)
var commandKeyWidth = CGFloat(0)
var keyboardLoad = false

// Keyboard elements.
var spaceBar = String()

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
}

/// States of the keyboard corresponding to which auto actions should be presented.
enum AutoActionState {
  case complete
  case suggest
}

// Baseline state variables.
var keyboardState: KeyboardState = .letters
var shiftButtonState: ShiftButtonState = .normal
var commandState: CommandState = .idle
var autoActionState: AutoActionState = .suggest

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

/// Sets the keyboard layout and its alternate keys.
func setKeyboard() {
  setKeyboardLayout()
  setKeyboardAlternateKeys()
}

/// Sets the keyboard layouts given the chosen keyboard and device type.
func setKeyboardLayout() {
  print("SetKeyBoardLayout")
}

// Variables that define which keys are positioned on the very left, right or in the center of the keyboard.
// The purpose of these is to define which key pop up functions should be ran.
var centralKeyChars: [String] = [String]()
var leftKeyChars: [String] = [String]()
var rightKeyChars: [String] = [String]()

// Variables for call out positioning.
var horizStart = CGFloat(0)
var vertStart = CGFloat(0)
var widthMultiplier = CGFloat(0)
var maxHeightMultiplier = CGFloat(0)
var maxHeight = CGFloat(0)
var heightBeforeTopCurves = CGFloat(0)
var maxWidthCurveControl = CGFloat(0)
var maxHeightCurveControl = CGFloat(0)
var minHeightCurveControl = CGFloat(0)

var keyPopChar = UILabel()
var keyHoldPopChar = UILabel()
var keyPopLayer = CAShapeLayer()
var keyHoldPopLayer = CAShapeLayer()

// MARK: English Interface Variables
// Note: here only until there is an English keyboard.

public enum EnglishKeyboardConstants {
  // Keyboard key layouts.
  static let lettersKeys = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", ":"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", ";"],
    ["tab", ",", "space", ".", "return"]
  ]
  
  static let commandKeys = [
    ["C++"], ["| \"", "\\ '"], ["< {", "( ["], ["> }", ") ]"], ["_ +", "- ="], ["delete"],
  ]
  
  static let numbersAndSymbols = [
    ["!", "1"], ["@", "2"], ["#", "3"], ["$", "4"], ["%", "5"], ["^", "6"], ["&", "7"], ["*", "8"], ["(", "9"], [")", "0"]
  ]
}
  
  /// Gets the keys for the English keyboard.
  func getENKeys() {
    letterKeys = EnglishKeyboardConstants.lettersKeys
    commandKeys = EnglishKeyboardConstants.commandKeys
    allKeys = Array(letterKeys.joined())  + Array(numberKeys.joined()) + Array(commandKeys.joined())
    
    leftKeyChars = ["q", "1", "a"]
    rightKeyChars = ["p", "0", ":", ";"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }
  
  /// Provides an English keyboard layout.
  func setENKeyboardLayout() {
    getENKeys()
    spaceBar = "space"
  }
