//
//  NumberKey.swift
//  MainKeyBoard
//
//  Created by GlintonLiao on 2022/12/25.
//

import Foundation
import UIKit

class NumberKey: UIButton {
  
  func setConfig(idx: Int) {
    var configuration = UIButton.Configuration.plain()
    var r1 = EnglishKeyboardConstants.numbersAndSymbols[idx][0]
    var r2 = EnglishKeyboardConstants.numbersAndSymbols[idx][1]
    
    if shiftButtonState != .normal {
      let temp = r1;
      r1 = r2;
      r2 = temp
    }
    
    configuration.attributedTitle = AttributedString(r1, attributes: AttributeContainer([
      NSAttributedString.Key.foregroundColor: UIColor(
        red: 100/255.0,
        green: 100/255.0,
        blue: 100/255.0,
        alpha: 0.9),
      NSAttributedString.Key.font: UIFont(name: "Menlo", size: 12)!
    ]))
    configuration.attributedSubtitle = AttributedString(r2, attributes: AttributeContainer([
      NSAttributedString.Key.foregroundColor: UIColor(
        red: 20/255.0,
        green: 20/255.0,
        blue: 20/255.0,
        alpha: 1.0),
      NSAttributedString.Key.font: UIFont(name: "Menlo", size: 16)!
    ]))
    configuration.titleAlignment = .center
    self.configuration = configuration
    
    self.layer.setValue(r2, forKey: "original")
    self.layer.setValue(r2, forKey: "keyToDisplay")
    self.layer.setValue(false, forKey: "isSpecial")
  }
  
  func style() {
    self.backgroundColor = keyColor
    self.layer.cornerRadius = keyCornerRadius
    self.layer.shadowColor = keyShadowColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
    self.layer.masksToBounds = false
  }
}
