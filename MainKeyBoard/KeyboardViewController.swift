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
  let notificationCenter = NotificationCenter.default
  let pasteboard = UIPasteboard.general
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    checkLandscapeMode()
    let heightConstraint: NSLayoutConstraint;
    // Add custom view sizing constraints here
    if isLandscapeView {
      heightConstraint = NSLayoutConstraint(
        item: view!,
        attribute: NSLayoutConstraint.Attribute.height,
        relatedBy: NSLayoutConstraint.Relation.equal,
        toItem: nil,
        attribute: NSLayoutConstraint.Attribute.notAnAttribute,
        multiplier: 1.0,
        constant: 280
      )
    } else {
      heightConstraint = NSLayoutConstraint(
        item: view!,
        attribute: NSLayoutConstraint.Attribute.height,
        relatedBy: NSLayoutConstraint.Relation.equal,
        toItem: nil,
        attribute: NSLayoutConstraint.Attribute.notAnAttribute,
        multiplier: 1.0,
        constant: 380
      )
    }
    view.addConstraint(heightConstraint)
    keyboardView.frame.size = view.frame.size
  }
  
  // load nib layout file
  func loadInterface() {
    let keyBoardNib = UINib(nibName: "Keyboard", bundle: nil)
    keyboardView = keyBoardNib.instantiate(withOwner: self, options: nil)[0] as? UIView
    keyboardView.translatesAutoresizingMaskIntoConstraints = true
    view.addSubview(keyboardView)
    loadKeys()
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
    
    if autosuggestions[prefix.lowercased()].exists() {
      let suggestions: [String] = autosuggestions[prefix.lowercased()].rawValue as! [String]
      completionWords = [String]()
      for i in 0..<3 {
        completionWords.append(suggestions[i])
      }
      UIView.animate(withDuration: 0.2) {
        self.suggestion0.titleLabel?.alpha = 0.0
        self.suggestion1.titleLabel?.alpha = 0.0
        self.suggestion2.titleLabel?.alpha = 0.0
      }
      UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn) {
        self.suggestion0.titleLabel?.alpha = 1.0
        self.suggestion1.titleLabel?.alpha = 1.0
        self.suggestion2.titleLabel?.alpha = 1.0
      }
    }

    suggestion0.titleLabel?.font = UIFont(name: "Menlo", size: 18)
    suggestion1.titleLabel?.font = UIFont(name: "Menlo", size: 18)
    suggestion2.titleLabel?.font = UIFont(name: "Menlo", size: 18)
    
    suggestion0.setTitle(completionWords[0], for: .normal)
    suggestion1.setTitle(completionWords[1], for: .normal)
    suggestion2.setTitle(completionWords[2], for: .normal)
    
    suggestion0.addTarget(self, action: #selector(executeAutoSuggestion), for: .touchUpInside)
    suggestion1.addTarget(self, action: #selector(executeAutoSuggestion), for: .touchUpInside)
    suggestion2.addTarget(self, action: #selector(executeAutoSuggestion), for: .touchUpInside)
    
    suggestion0.addTarget(self, action: #selector(suggestionTouchDown), for: .touchDown)
    suggestion1.addTarget(self, action: #selector(suggestionTouchDown), for: .touchDown)
    suggestion2.addTarget(self, action: #selector(suggestionTouchDown), for: .touchDown)
  }
  
  @IBAction func suggestionTouchDown(_ sender: UIButton) {
    sender.backgroundColor = keyPressedColor
  }
  
  @IBAction func executeAutoSuggestion(_ sender: UIButton) {
    proxy.insertText(sender.titleLabel?.text ?? "")
    proxy.insertText(" ")
    setAutoSuggestion()
    sender.backgroundColor = .clear
    loadKeys()
  }
    
  // button state control
  func activateBtn(btn: UIButton) {
    btn.addTarget(self, action: #selector(executeKeyActions), for: .touchUpInside)
    btn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
    btn.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
    btn.isUserInteractionEnabled = true
  }
  
  @objc func openURL(_ url: URL) { return }

  func openApp(_ urlstring:String) {
    var responder: UIResponder? = self as UIResponder
    let selector = #selector(openURL(_:))
    while responder != nil {
      if responder!.responds(to: selector) && responder != self {
        responder!.perform(selector, with: URL(string: urlstring)!)
        return
      }
      responder = responder?.next
    }
  }
  
  @IBAction func executeKeyActions(_ sender: UIButton) {
    guard let originalKey = sender.layer.value(
      forKey: "original"
    ) as? String,
      let keyToDisplay = sender.layer.value(
        forKey: "keyToDisplay"
    ) as? String,
          let isSpecial = sender.layer.value(
        forKey: "isSpecial"
    ) as? Bool else {
      return
    }
    
    sender.backgroundColor = isSpecial ? specialKeyColor : keyColor
    
    switch originalKey {
    case "return":
      proxy.insertText("\n")

    case "delete":
      if commandState != .idle {
        commandState = .idle
        loadKeys()
      } else {
        proxy.deleteBackward()
        loadKeys()
      }
    
    case "lang":
      openApp("key-board-app://")

    case "space":
      proxy.insertText(" ")

    case "tab":
      if shiftButtonState == .normal {
        proxy.insertText("    ")
      } else {
        for _ in 0..<4 {
          proxy.deleteBackward()
        }
      }

    case "shift":
      shiftButtonState = shiftButtonState == .normal ? .shift : .normal
      loadKeys()

    case "colon":
      commandState = .colon
      loadKeys()

    case "leftPa":
      commandState = .leftPa
      loadKeys()

    case "rightPa":
      commandState = .rightPa
      loadKeys()

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
    setAutoSuggestion()
  }
  
  // change style of btn when touchdown and up
  @objc func keyTouchDown(_ sender: UIButton) {
    guard let key = sender.layer.value(forKey: "original") as? String else { return }
    if key == "lang" { return }
    sender.backgroundColor = keyPressedColor
    if key == "delete" {
      styleDeleteButton(sender, isPressed: true)
    }
  }
  
  /// Resets key coloration after they have been changed to keyPressedColor.
  ///
  /// - Parameters
  ///   - sender: the key that was pressed.
  @objc func keyUntouched(_ sender: UIButton) {
    guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else { return }
    sender.backgroundColor = isSpecial ? specialKeyColor : keyColor
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

  func loadCommandKeys() {
    for i in 0..<EnglishKeyboardConstants.commandKeys.count {
      let btn = CommandKey(type: .custom)
      btn.style()
      btn.setConfig(idx: i)
      btn.addSwipeGesture()
      btn.widthAnchor.constraint(equalToConstant: commandKeyWidth).isActive = true
      activateBtn(btn: btn)
      keyboardKeys.append(btn)
      stackView1.addArrangedSubview(btn)
    }
  }
  
  func loadNumberKeys() {
    for i in 0..<EnglishKeyboardConstants.numbersAndSymbols.count {
      let btn = NumberKey(type: .custom)
      btn.style()
      btn.setConfig(idx: i)
      btn.addSwipeGesture()
      btn.widthAnchor.constraint(equalToConstant: letterKeyWidth).isActive = true
      activateBtn(btn: btn)
      keyboardKeys.append(btn)
      stackView2.addArrangedSubview(btn)
    }
  }
  
  func loadKeys() {
    letterKeys = EnglishKeyboardConstants.lettersKeys
    if isLandscapeView {
      letterKeyWidth = (UIScreen.main.bounds.height - 5) / CGFloat(letterKeys[0].count) * 1.5
      commandKeyWidth = (UIScreen.main.bounds.height - 5) / 6 * 1.5
      keyCornerRadius = letterKeyWidth / 8
    } else {
      letterKeyWidth = (UIScreen.main.bounds.width - 6) / CGFloat(letterKeys[0].count) * 0.875
      commandKeyWidth = (UIScreen.main.bounds.width - 6) / 6 * 0.935
      keyCornerRadius = letterKeyWidth / 6
    }
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
    setAutoPartition()
    setAutoSuggestion()
    
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
        
        if btn.key == "selectKeyboard" {
          self.nextKeyboardButton = btn
          self.nextKeyboardButton.addTarget(
            self,
            action: #selector(handleInputModeList(from:with:)),
            for: .allTouchEvents
          )
          styleIconBtn(btn: btn, color: keyCharColor, iconName: "globe")
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
    keyboardLoad = true
    loadInterface()
    keyboardLoad = false

    self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // update the languagemode
    if let message = pasteboard.string {
      language = message
      autosuggestions = loadJSON(filename: language)
    }
    
    updateViewConstraints()
    keyboardLoad = true
    loadKeys()
    keyboardLoad = false
  }
  
  /// Includes:
  /// - updateViewConstraints to change the keyboard height
  /// - A call to loadKeys to reload the display after an orientation change
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    updateViewConstraints()
    keyboardLoad = true
    loadKeys()
    keyboardLoad = false
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
