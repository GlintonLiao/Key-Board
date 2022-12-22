//
//  KeyboardViewController.swift
//  MainKeyBoard
//
//  Created by GlintonLiao on 2022/12/19.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
  var keyboardView: UIView!
  
  @IBOutlet weak var stackView0: UIStackView!
  @IBOutlet weak var stackView1: UIStackView!
  @IBOutlet weak var stackView2: UIStackView!
  @IBOutlet weak var stackView3: UIStackView!
  @IBOutlet weak var stackView4: UIStackView!
  @IBOutlet weak var stackView5: UIStackView!
  @IBOutlet weak var stackView6: UIStackView!
  @IBOutlet var nextKeyboardButton: UIButton!
  @IBOutlet weak var suggestion0: UIButton!
  @IBOutlet weak var partition1: UILabel!
  @IBOutlet weak var suggestion1: UIButton!
  @IBOutlet weak var sugestion2: UIButton!
  @IBOutlet weak var partition0: UILabel!
  
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
  
  func loadKeys() {
    letterKeys = EnglishKeyboardConstants.lettersKeys
    letterKeyWidth = (UIScreen.main.bounds.width - 6) / CGFloat(letterKeys[0].count) * 0.875
    commandKeyWidth = (UIScreen.main.bounds.width - 6) / 6 * 0.935
    numSymKeyWidth = letterKeyWidth
    keyCornerRadius = letterKeyWidth / 6
    keyWidth = letterKeyWidth
    for view in [stackView0, stackView1, stackView2, stackView3, stackView4, stackView5, stackView6] {
      view?.isUserInteractionEnabled = true
      view?.isLayoutMarginsRelativeArrangement = true

      // Set edge insets for stack views to provide vertical key spacing.
      if view == stackView0 {
        view?.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
      } else if view == stackView1 {
        view?.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
      } else if view == stackView2 {
        view?.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
      } else if view == stackView3 {
        view?.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
      } else if view == stackView4 {
        view?.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
      } else if view == stackView5 {
        view?.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
      } else if view == stackView6 {
        view?.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
      }
    }
    
    // set the command line
    for i in 0..<EnglishKeyboardConstants.commandKeys.count {
      let btn = KeyboardKey(type: .custom)
      btn.style()
      var configuration = UIButton.Configuration.plain()
      if i == 0 {
        configuration.attributedTitle = AttributedString("C++", attributes: AttributeContainer([
          NSAttributedString.Key.foregroundColor: UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 1.0),
          NSAttributedString.Key.font: UIFont(name: "Menlo", size: 20)!
        ]))
        btn.backgroundColor = .systemPink
      } else if i == EnglishKeyboardConstants.commandKeys.count - 1 {
        styleDeleteButton(btn, isPressed: false)
        btn.backgroundColor = specialKeyColor
      } else {
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
      }
      btn.configuration = configuration
      btn.widthAnchor.constraint(equalToConstant: commandKeyWidth).isActive = true
      stackView1.addArrangedSubview(btn)
    }
    
    // set the numbers line
    for i in 0..<EnglishKeyboardConstants.numbersAndSymbols.count {
      let btn = KeyboardKey(type: .custom)
      btn.style()
      var configuration = UIButton.Configuration.plain()
      let r1 = EnglishKeyboardConstants.numbersAndSymbols[i][0]
      let r2 = EnglishKeyboardConstants.numbersAndSymbols[i][1]
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
      stackView2.addArrangedSubview(btn)
    }
    
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
        var leftPadding = CGFloat(0)
        var widthOfSpacing = CGFloat(0)
        widthOfSpacing = (
          (UIScreen.main.bounds.width - 6.0)
          - (CGFloat(letterKeys[0].count) * keyWidth)
          ) / (CGFloat(letterKeys[0].count)
          - 1.0
        )
        if leftPadding == CGFloat(0) {
          btn.leftShift = -(widthOfSpacing / 2)
        } else {
          btn.leftShift = -(leftPadding)
        }
        var rightPadding = CGFloat(0)
        if rightPadding == CGFloat(0) {
          btn.rightShift = -(widthOfSpacing / 2)
        } else {
          btn.rightShift = -(rightPadding)
        }
        
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
      
        print("Load")
        proxy = textDocumentProxy as UITextDocumentProxy
        loadInterface()
        loadKeys()
        setAutoPartition()
        
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
