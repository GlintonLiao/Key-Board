//
//  KeyboardKey.swift
//
//  Classes and variables that define keys for keyboards.
//

import UIKit

// The keys collection as well as one for the padding for placements.
var keyboardKeys: [UIButton] = []
var paddingViews: [UIButton] = []

/// Class of UIButton that allows the tap area to be increased so that edges between keys can still receive user input.
class KeyboardKey: UIButton {
  // Properties for the touch area - passing negative values will expand the touch area.
  var topShift = CGFloat(0)
  var leftShift = CGFloat(0)
  var bottomShift = CGFloat(0)
  var rightShift = CGFloat(0)

  /// Allows the bounds of the key to be expanded.
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return bounds.inset(by: UIEdgeInsets(
      top: topShift,
      left: leftShift,
      bottom: bottomShift,
      right: rightShift)
    ).contains(point)
  }

  var row: Int!
  var idx: Int!
  var key: String!

  /// Styles the key with a color, corner radius and shadow.
  func style() {
    self.backgroundColor = keyColor
    self.layer.cornerRadius = keyCornerRadius
    self.layer.shadowColor = keyShadowColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
    self.layer.masksToBounds = false
  }

  /// Sets the character of the key and defines its capitalized state.
  func setChar() {
    self.key = keyboard[self.row][self.idx]
    var capsKey = ""

    if self.key != "tab"
        && self.key != ":"
        && self.key != "space"
        && self.key != ";"
        && self.key != ","
        && self.key != "."
        && self.key != "selectKeyBoard"{
      capsKey = keyboard[self.row][self.idx].capitalized
    } else {
      capsKey = self.key
    }
    let keyToDisplay = shiftButtonState == .normal ? self.key : capsKey
    self.setTitleColor(keyCharColor, for: .normal)
    self.layer.setValue(self.key, forKey: "original")
    self.layer.setValue(keyToDisplay, forKey: "keyToDisplay")
    self.layer.setValue(false, forKey: "isSpecial")
    self.setTitle(keyToDisplay, for: .normal) // set button character
  }

  /// Sets the character size of a capital key if the device is an iPhone given the orientation.
  func setPhoneCapCharSize() {
    if isLandscapeView {
      if self.key == "space" {
        self.titleLabel?.font = UIFont(name: "Menlo", size: letterKeyWidth / 10)
      } else {
        self.titleLabel?.font = UIFont(name: "Menlo", size: letterKeyWidth / 5)
      }
    } else {
      if self.key == "space" {
        self.titleLabel?.font = UIFont(name: "Menlo", size: letterKeyWidth / 4)
      } else {
        self.titleLabel?.font = UIFont(name: "Menlo", size: letterKeyWidth / 2)
      }
    }
  }

  /// Checks if the character is a lower case letter and adjusts it if so.
  func checkSetPhoneLowerCharSize() {
    guard let isSpecial = self.layer.value(forKey: "isSpecial") as? Bool else { return }

    if isSpecial == false
        && shiftButtonState == .normal {
      if isLandscapeView {
        self.titleLabel?.font = UIFont(name: "Menlo", size: letterKeyWidth / 3)
      } else {
        self.titleLabel?.font = UIFont(name: "Menlo", size: letterKeyWidth / 1.5)
      }
    } else {
      if isLandscapeView {
        self.titleLabel?.font = UIFont(name: "Menlo", size: letterKeyWidth / 3)
      } else {
        self.titleLabel?.font = UIFont(name: "Menlo", size: letterKeyWidth / 1.5)
      }
    }
    
    if self.key == ":"
        || self.key == ";"
        || self.key == "."
        || self.key == ","
        || self.key == "space" {
      if isLandscapeView {
        self.titleLabel?.font = UIFont(name: "Menlo", size: letterKeyWidth / 4)
      } else {
        self.titleLabel?.font = UIFont(name: "Menlo", size: letterKeyWidth / 2)
      }
    }
  }

  /// Sets the character size of a key if the device is an iPhone.
  func setPhoneCharSize() {
    setPhoneCapCharSize()
    checkSetPhoneLowerCharSize()
  }

  /// Sets the key character sizes depending on device type and orientation.
  func setCharSize() {
    setPhoneCharSize()
  }

  /// Adjusts the width of a key if it's one of the special characters on the iPhone keyboard.
  func adjustPhoneKeyWidth() {
    if self.key == "tab" {
      self.layer.setValue(true, forKey: "isSpecial")
      self.widthAnchor.constraint(equalToConstant: keyWidth * 2 + keyWidth / 0.875 * 0.125).isActive = true
    } else if self.key == "delete"
      || self.key == "shift" {
        self.layer.setValue(true, forKey: "isSpecial")
        self.widthAnchor.constraint(equalToConstant: keyWidth * 2 + keyWidth / 0.875 * 0.125).isActive = true
    } else if self.key == "selectKeyboard" {
      self.layer.setValue(true, forKey: "isSpecial")
      self.widthAnchor.constraint(equalToConstant: keyWidth * 1 + keyWidth / 0.875 * 0.125).isActive = true
    } else if self.key == "return" {
        self.layer.setValue(true, forKey: "isSpecial")
        self.widthAnchor.constraint(equalToConstant: keyWidth * 2 + keyWidth / 0.875 * 0.125).isActive = true
    } else if self.key == "space" {
      self.widthAnchor.constraint(equalToConstant: keyWidth * 4 + keyWidth / 0.875 * 0.125 * 3).isActive = true
    } else {
      self.widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
    }
  }

  /// Adjusts the width of a key if it's one of the special characters on the keyboard.
  func adjustKeyWidth() {
    adjustPhoneKeyWidth()

    guard let isSpecial = self.layer.value(forKey: "isSpecial") as? Bool else { return }

    if self.key == "shift" {
      // Switch the shift key icon given its state.
      if shiftButtonState == .shift {
        self.backgroundColor = keyPressedColor
        styleIconBtn(btn: self, color: UIColor.label, iconName: "shift.fill")
      } else if shiftButtonState == .caps {
        self.backgroundColor = keyPressedColor
        styleIconBtn(btn: self, color: UIColor.label, iconName: "capslock.fill")
      } else {
        self.backgroundColor = specialKeyColor
        styleIconBtn(btn: self, color: UIColor.label, iconName: "shift")
      }
    } else if self.key == "return" {
      // Color the return key depending on if it's being used as enter for commands.
      self.backgroundColor = commandKeyColor
      styleIconBtn(btn: self, color: UIColor.label, iconName: "return")
    } else if self.key == "tab" {
      self.backgroundColor = commandKeyColor
      if shiftButtonState == .normal {
        styleIconBtn(btn: self, color: UIColor.label, iconName: "arrow.right.to.line")
      } else {
        styleIconBtn(btn: self, color: UIColor.label, iconName: "arrow.left.to.line")
      }
    } else if isSpecial == true {
      self.backgroundColor = specialKeyColor
    }
  }
}

/// Sets a button's values that are displayed and inserted into the proxy as well as assigning a color.
///
/// - Parameters
///   - btn: the button to be set up.
///   - color: the color to assign to the background.
///   - name: the name of the value for the key.
///   - canCap: whether the key receives a special character for the shift state.
///   - isSpecial: whether the btn should be marked as special to be colored accordingly.
func setBtn(btn: UIButton, color: UIColor, name: String, canCap: Bool, isSpecial: Bool) {
  btn.backgroundColor = color
  btn.layer.setValue(name, forKey: "original")

  var capsKey = ""
  if canCap == true {
    capsKey = name.capitalized
    let shiftChar = shiftButtonState == .normal ? name : capsKey
    btn.layer.setValue(shiftChar, forKey: "keyToDisplay")
  } else {
    btn.layer.setValue(name, forKey: "keyToDisplay")
  }
  btn.layer.setValue(isSpecial, forKey: "isSpecial")
}
