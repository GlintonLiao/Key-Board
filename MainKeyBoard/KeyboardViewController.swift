//
//  KeyboardViewController.swift
//  MainKeyBoard
//
//  Created by GlintonLiao on 2022/12/19.
//

import UIKit

class KeyboardViewController: UIInputViewController {
  @IBOutlet weak var stackView0: UIStackView!
  @IBOutlet weak var stackView1: UIStackView!
  @IBOutlet weak var stackView2: UIStackView!
  @IBOutlet weak var stackView3: UIStackView!
  @IBOutlet weak var stackView4: UIStackView!
  @IBOutlet weak var stackView5: UIStackView!
  @IBOutlet weak var stackView6: UIStackView!
  @IBOutlet var nextKeyboardButton: UIButton!
  
  @IBOutlet weak var suggestion0: UIButton!
  @IBOutlet weak var suggestion1: UIButton!
  @IBOutlet weak var suggestion2: UIButton!
  @IBOutlet weak var partition1: UILabel!
  @IBOutlet weak var partition0: UILabel!
  
  var keyboardView: UIView!
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
      
      // Add custom view sizing constraints here
    let heightConstraint = NSLayoutConstraint(
      item: view!,
      attribute: NSLayoutConstraint.Attribute.height,
      relatedBy: NSLayoutConstraint.Relation.equal,
      toItem: nil,
      attribute: NSLayoutConstraint.Attribute.notAnAttribute,
      multiplier: 1.0,
      constant: 380
    )
    view.addConstraint(heightConstraint)

    keyboardView.frame.size = view.frame.size
  }
  
  func loadInterface() {
    let keyBoardNib = UINib(nibName: "Keyboard", bundle: nil)
    keyboardView = keyBoardNib.instantiate(withOwner: self, options: nil)[0] as? UIView
    keyboardView.translatesAutoresizingMaskIntoConstraints = true
    view.addSubview(keyboardView)
  }
  
  func setAutoPartition() {
    if UITraitCollection.current.userInterfaceStyle == .light {
      partition0.backgroundColor = specialKeyColor
      partition1.backgroundColor = specialKeyColor
    } else {
      partition0.backgroundColor = UIColor(cgColor: commandBarBorderColor)
      partition1.backgroundColor = UIColor(cgColor: commandBarBorderColor)
    }
  }
  
  func setAutoSuggestion() {
    completionWords = ["void", "int", "string"]
    
    let prefix = proxy.documentContextBeforeInput?.components(separatedBy: " ").secondToLast() ?? ""

    suggestion0.titleLabel?.font = UIFont(name: "Menlo", size: 18)
    suggestion1.titleLabel?.font = UIFont(name: "Menlo", size: 18)
    suggestion2.titleLabel?.font = UIFont(name: "Menlo", size: 18)
    
    suggestion0.setTitle(completionWords[0], for: .normal)
    suggestion1.setTitle(completionWords[1], for: .normal)
    suggestion2.setTitle(completionWords[2], for: .normal)
  }
  
  // button state control
  func activateBtn(btn: UIButton) {
    btn.addTarget(self, action: #selector(executeKeyActions), for: .touchUpInside)
    btn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
    btn.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
    btn.isUserInteractionEnabled = true
  }
  
  @IBAction func executeKeyActions(_ sender: UIButton) {
    guard let originalKey = sender.layer.value(
      forKey: "original"
    ) as? String,
      let keyToDisplay = sender.layer.value(forKey: "keyToDisplay") as? String else {
      return
    }
    
    guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else { return }
    sender.backgroundColor = isSpecial ? specialKeyColor : keyColor
    
    switch originalKey {
    case "return":
      proxy.insertText("\n")
      break
    case "delete":
      if commandState != .idle {
        commandState = .idle
        loadKeys()
      } else {
        proxy.deleteBackward()
        loadKeys()
      }
      break
    case "space":
      proxy.insertText(" ")
      break
    case "tab":
      if shiftButtonState == .normal {
        proxy.insertText("    ")
      } else {
        for _ in 0..<4 {
          proxy.deleteBackward()
        }
      }
      break
    case "shift":
      shiftButtonState = shiftButtonState == .normal ? .shift : .normal
      loadKeys()
      break
    case "colon":
      commandState = .colon
      loadKeys()
      print("colon")
      break
    case "leftPa":
      commandState = .leftPa
      loadKeys()
      break
    case "rightPa":
      commandState = .rightPa
      loadKeys()
      break
    case "line":
      commandState = .line
      loadKeys()
    default:
      proxy.insertText(keyToDisplay)
      if shiftButtonState == .shift {
        shiftButtonState = .normal
        loadKeys()
      }
      if commandState != .idle {
        commandState = .idle
        loadKeys()
      }
    }
  }
  
  // change style of btn when touchdown and up
  @objc func keyTouchDown(_ sender: UIButton) {
    guard let key = sender.layer.value(forKey: "original") as? String else { return }
    sender.backgroundColor = keyPressedColor
    if key == "delete" {
      styleDeleteButton(sender, isPressed: true)
    }
  }
  
  @objc func keyUntouched(_ sender: UIButton) {
    guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else { return }
    guard let originalKey = sender.layer.value(forKey: "original") as? String else { return }
    sender.backgroundColor = isSpecial ? specialKeyColor : keyColor
    print("untouch")
    if originalKey == "delete" {
      print("untouch")
      styleDeleteButton(sender, isPressed: false)
    }
  }
  
  @objc func keyMultiPress(_ sender: UIButton, event: UIEvent) {
    guard let originalKey = sender.layer.value(forKey: "original") as? String else { return }
    let touch: UITouch = event.allTouches!.first!
    
    // caps lock for two taps of shift
    if touch.tapCount == 2 && originalKey == "shift" {
      shiftButtonState = .caps
      loadKeys()
    }
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
  
  // set command bar
  func loadCommandKeys() {
    for i in 0..<EnglishKeyboardConstants.commandKeys.count {
      let btn = KeyboardKey(type: .custom)
      btn.style()
      var configuration = UIButton.Configuration.plain()
      if i == 0 {  // coding language
        configuration.attributedTitle = AttributedString("C++", attributes: AttributeContainer([
          NSAttributedString.Key.foregroundColor: UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 1.0),
          NSAttributedString.Key.font: UIFont(name: "Menlo", size: 20)!
        ]))
        btn.backgroundColor = .systemPink
      } else if i == EnglishKeyboardConstants.commandKeys.count - 1 { // delete
        styleDeleteButton(btn, isPressed: false)
        let deleteLongPressRecongizer = UILongPressGestureRecognizer(target: self, action: #selector(deleteLongPressed(_:)))
        btn.addGestureRecognizer(deleteLongPressRecongizer)
        btn.backgroundColor = specialKeyColor
        btn.layer.setValue("delete", forKey: "original")
        btn.layer.setValue("delete", forKey: "keyToDisplay")
        btn.layer.setValue(true, forKey: "isSpecial")
      } else {
        switch commandState {
        case .idle:
          let r1 = EnglishKeyboardConstants.commandKeys[i][0]
          let r2 = EnglishKeyboardConstants.commandKeys[i][1]
          configuration.attributedTitle = AttributedString(r1, attributes: AttributeContainer([
            NSAttributedString.Key.foregroundColor: UIColor(
              red: 20/255.0,
              green: 20/255.0,
              blue: 20/255.0,
              alpha: 1.0),
            NSAttributedString.Key.font: UIFont(name: "Menlo", size: 15)!
          ]))
          configuration.attributedSubtitle = AttributedString(r2, attributes: AttributeContainer([
            NSAttributedString.Key.foregroundColor: UIColor(
              red: 20/255.0,
              green: 20/255.0,
              blue: 20/255.0,
              alpha: 1.0),
            NSAttributedString.Key.font: UIFont(name: "Menlo", size: 15)!
          ]))
          btn.layer.setValue(baseKeySet[i], forKey: "original")
          btn.layer.setValue(baseKeySet[i], forKey: "keyToDisplay")
          btn.layer.setValue(false, forKey: "isSpecial")
          break

        case .colon:
          let str = keySet0[i]
          configuration.attributedTitle = AttributedString(str, attributes: AttributeContainer([
            NSAttributedString.Key.foregroundColor: UIColor(
              red: 20/255.0,
              green: 20/255.0,
              blue: 20/255.0,
              alpha: 1.0),
            NSAttributedString.Key.font: UIFont(name: "Menlo", size: 20)!
          ]))
          btn.layer.setValue(str, forKey: "original")
          btn.layer.setValue(str, forKey: "keyToDisplay")
          btn.layer.setValue(false, forKey: "isSpecial")
          break
          
        case .leftPa:
          let str = keySet1[i]
          configuration.attributedTitle = AttributedString(str, attributes: AttributeContainer([
            NSAttributedString.Key.foregroundColor: UIColor(
              red: 20/255.0,
              green: 20/255.0,
              blue: 20/255.0,
              alpha: 1.0),
            NSAttributedString.Key.font: UIFont(name: "Menlo", size: 20)!
          ]))
          btn.layer.setValue(str, forKey: "original")
          btn.layer.setValue(str, forKey: "keyToDisplay")
          btn.layer.setValue(false, forKey: "isSpecial")
          break

        case .rightPa:
          let str = keySet2[i]
          configuration.attributedTitle = AttributedString(str, attributes: AttributeContainer([
            NSAttributedString.Key.foregroundColor: UIColor(
              red: 20/255.0,
              green: 20/255.0,
              blue: 20/255.0,
              alpha: 1.0),
            NSAttributedString.Key.font: UIFont(name: "Menlo", size: 20)!
          ]))
          btn.layer.setValue(str, forKey: "original")
          btn.layer.setValue(str, forKey: "keyToDisplay")
          btn.layer.setValue(false, forKey: "isSpecial")
          break

        case .line:
          let str = keySet3[i]
          configuration.attributedTitle = AttributedString(str, attributes: AttributeContainer([
            NSAttributedString.Key.foregroundColor: UIColor(
              red: 20/255.0,
              green: 20/255.0,
              blue: 20/255.0,
              alpha: 1.0),
            NSAttributedString.Key.font: UIFont(name: "Menlo", size: 20)!
          ]))
          btn.layer.setValue(str, forKey: "original")
          btn.layer.setValue(str, forKey: "keyToDisplay")
          btn.layer.setValue(false, forKey: "isSpecial")
          break
        }
      }
      btn.configuration = configuration
      btn.widthAnchor.constraint(equalToConstant: commandKeyWidth).isActive = true
      activateBtn(btn: btn)
      keyboardKeys.append(btn)
      stackView1.addArrangedSubview(btn)
    }
  }
  
  func loadNumberKeys() {
    // set the numbers line
    for i in 0..<EnglishKeyboardConstants.numbersAndSymbols.count {
      let btn = KeyboardKey(type: .custom)
      btn.style()
      var configuration = UIButton.Configuration.plain()
      var r1 = EnglishKeyboardConstants.numbersAndSymbols[i][0]
      var r2 = EnglishKeyboardConstants.numbersAndSymbols[i][1]
      
      if shiftButtonState == .shift {
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
      btn.configuration = configuration
      btn.widthAnchor.constraint(equalToConstant: letterKeyWidth).isActive = true
      
      btn.layer.setValue(r2, forKey: "original")
      btn.layer.setValue(r2, forKey: "keyToDisplay")
      btn.layer.setValue(false, forKey: "isSpecial")
      
      activateBtn(btn: btn)
      keyboardKeys.append(btn)
      stackView2.addArrangedSubview(btn)
    }
  }
  
  func loadKeys() {
    letterKeys = EnglishKeyboardConstants.lettersKeys
    letterKeyWidth = (UIScreen.main.bounds.width - 6) / CGFloat(letterKeys[0].count) * 0.875
    commandKeyWidth = (UIScreen.main.bounds.width - 6) / 6 * 0.935
    keyCornerRadius = letterKeyWidth / 6
    keyWidth = letterKeyWidth
    
    // clear the previous layout
    keyboardKeys.forEach {$0.removeFromSuperview()}

    for view in [stackView0, stackView1, stackView2, stackView3, stackView4, stackView5, stackView6] {
      view?.isUserInteractionEnabled = true
      view?.isLayoutMarginsRelativeArrangement = true

      // Set edge insets for stack views to provide vertical key spacing.
      view?.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    }
    
    loadCommandKeys()
    loadNumberKeys()
    
    let numRows = letterKeys.count
    keyboard = letterKeys
    for row in 0..<numRows {
      for idx in 0..<keyboard[row].count {
        // Set up button as a key with its values and properties.
        let btn = KeyboardKey(type: .custom)
        btn.row = row
        btn.idx = idx
        btn.style()
        btn.setChar()
        btn.setCharSize()
        
        btn.adjustKeyWidth()
        
        keyboardKeys.append(btn)
        
        if btn.key == "shift" {
          btn.addTarget(self, action: #selector(keyMultiPress(_:event:)), for: .touchDownRepeat)
        }
        
        switch row {
        case 0:
          btn.topShift = -5
          btn.bottomShift = -6
        case 1:
          btn.topShift = -6
          btn.bottomShift = -6
        case 2:
          btn.topShift = -6
          btn.bottomShift = -6
        case 3:
          btn.topShift = -6
          btn.bottomShift = -5
        default:
          break
        }

        // Pad left and right based on if the button has been shifted.
        let widthOfSpacing = (
          (UIScreen.main.bounds.width - 6.0)
          - (CGFloat(letterKeys[0].count) * keyWidth)
          ) / (CGFloat(letterKeys[0].count)
          - 1.0
        )
        btn.leftShift = -(widthOfSpacing / 2)
        btn.rightShift = -(widthOfSpacing / 2)
        
        activateBtn(btn: btn)
        
        switch row {
        case 0: stackView3.addArrangedSubview(btn)
        case 1: stackView4.addArrangedSubview(btn)
        case 2: stackView5.addArrangedSubview(btn)
        case 3: stackView6.addArrangedSubview(btn)
        default:
          break
        }
      }
    }
  }
    
    override func viewDidLoad() {
      super.viewDidLoad()

      proxy = textDocumentProxy as UITextDocumentProxy
      loadInterface()
      loadKeys()
      setAutoPartition()
      setAutoSuggestion()
      
      // Perform custom UI setup here
      self.nextKeyboardButton = UIButton(type: .system)

      self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
      self.nextKeyboardButton.sizeToFit()
      self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false

      self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)

      self.view.addSubview(self.nextKeyboardButton)

      self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
      self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
}
