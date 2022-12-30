//
//  CommandKey.swift
//  MainKeyBoard
//
//  Created by GlintonLiao on 2022/12/25.
//

import Foundation
import UIKit

class CommandKey: UIButton {
  
  var keys = [String]()
  
  func setConfig(idx: Int) {
    var configuration = UIButton.Configuration.plain()
    switch idx {
    // language mode key
    case 0:
      configuration.attributedTitle = AttributedString(language, attributes: AttributeContainer([
        NSAttributedString.Key.foregroundColor: UIColor(
          red: 1,
          green: 1,
          blue: 1,
          alpha: 1.0),
        NSAttributedString.Key.font: UIFont(name: "Menlo", size: language == "Java" ? 15 : 20)!
      ]))
      
      // set background color
      if language == "C++" {
        self.backgroundColor = .systemPink
      } else if language == "Java" {
        self.backgroundColor = .systemIndigo
      } else if language == "Py" {
        self.backgroundColor = .systemPurple
      } else if language == "JS" {
        self.backgroundColor = .systemYellow
      }
      
      self.layer.setValue("lang", forKey: "original")
      self.layer.setValue("lang", forKey: "keyToDisplay")
      self.layer.setValue(false, forKey: "isSpecial")
    
    case 5:
      styleDeleteButton(self, isPressed: false)
      let deleteLongPressRecongizer = UILongPressGestureRecognizer(target: self, action: #selector(deleteLongPressed(_:)))
      self.addGestureRecognizer(deleteLongPressRecongizer)
      self.backgroundColor = specialKeyColor
      self.layer.setValue("delete", forKey: "original")
      self.layer.setValue("delete", forKey: "keyToDisplay")
      self.layer.setValue(true, forKey: "isSpecial")
      
    default:
      if commandState == .idle {
        switch idx {
        case 1:
          self.keys = keySet0
        case 2:
          self.keys = keySet1
        case 3:
          self.keys = keySet2
        case 4:
          self.keys = keySet3
        default:
          break
        }
        let r1 = EnglishKeyboardConstants.commandKeys[idx][0]
        let r2 = EnglishKeyboardConstants.commandKeys[idx][1]
        configuration.attributedTitle = AttributedString(r1, attributes: AttributeContainer([
          NSAttributedString.Key.foregroundColor: keyCharColor,
          NSAttributedString.Key.font: UIFont(name: "Menlo", size: 15)!
        ]))
        configuration.attributedSubtitle = AttributedString(r2, attributes: AttributeContainer([
          NSAttributedString.Key.foregroundColor: keyCharColor,
          NSAttributedString.Key.font: UIFont(name: "Menlo", size: 15)!
        ]))
        self.layer.setValue(baseKeySet[idx], forKey: "original")
        self.layer.setValue(baseKeySet[idx], forKey: "keyToDisplay")
        self.layer.setValue(false, forKey: "isSpecial")
      } else {
        var str = ""
        switch commandState {
        case .colon:
          str = keySet0[idx]
        case .leftPa:
          str = keySet1[idx]
        case .rightPa:
          str = keySet2[idx]
        case .line:
          str = keySet3[idx]
        default:
          break
        }
        configuration.attributedTitle = AttributedString(str, attributes: AttributeContainer([
          NSAttributedString.Key.foregroundColor: keyCharColor,
          NSAttributedString.Key.font: UIFont(name: "Menlo", size: 20)!
        ]))
        self.layer.setValue(str, forKey: "original")
        self.layer.setValue(str, forKey: "keyToDisplay")
        self.layer.setValue(false, forKey: "isSpecial")
      }
    }
    self.configuration = configuration
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
  
  @objc func handleSwipe(_ gesture: UIPanGestureRecognizer) {
    if gesture.state == .ended {
      if commandState != .idle || keys.isEmpty {
        self.backgroundColor = keyColor
        return
      }
      let trans = gesture.translation(in: gesture.view)
      var direction = 0
      // compress direction
      direction |= (trans.x > 0 ? 1 : 0) << 1
      direction |= (trans.y > 0 ? 1 : 0)
      proxy.insertText(keys[direction + 1])
      self.backgroundColor = keyColor
    }
  }
  
  func addSwipeGesture() {
    let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
    self.addGestureRecognizer(swipeGesture)
  }

  @objc func deleteLongPressed(_ gesture: UIGestureRecognizer) {
    // delete will be speed up base on the number of deletes that have been completed
    var deleteCount = 0
    if gesture.state == .began {
      backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
        (_) in
        deleteCount += 1
        proxy.deleteBackward()
        
        if deleteCount == 5 {
          backspaceTimer?.invalidate()
          backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) {
            (_) in
            deleteCount += 1
            proxy.deleteBackward()
            
            if deleteCount == 20 {
              backspaceTimer?.invalidate()
              backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) {
                (_) in
                proxy.deleteBackward()
              }
            }
          }
        }
      }
    } else if gesture.state == .ended || gesture.state == .cancelled {
      backspaceTimer?.invalidate()
      backspaceTimer = nil
      if let button = gesture.view as? UIButton {
        button.backgroundColor = specialKeyColor
        styleDeleteButton(button, isPressed: false)
      }
    }
  }
}
