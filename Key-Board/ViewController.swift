//
//  ViewController.swift
//
//  The ViewController for the Scribe app.
//

import UIKit

/// A UIViewController that provides instructions on how to install Keyboards as well as information about Scribe.
class ViewController: UIViewController {
  // Variables linked to elements in AppScreen.storyboard.
  @IBOutlet weak var appTextView: UITextView!

  @IBOutlet weak var openSettingsBtn: UIButton!
  @IBOutlet weak var switchLangBtn: UIButton!
  
  // Spacing views to size app screen proportionally.
  @IBOutlet weak var topSpace: UIView!
  @IBOutlet weak var bottomSpace: UIView!
  
  // gaps
  @IBOutlet weak var textGap: UIView!
  @IBOutlet weak var btnGap: UIView!

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func viewDidLoad() {
    super.viewDidLoad()
    setCurrentUI()
  }

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    setCurrentUI()
  }

  // Lock the device into portrait mode to avoid resizing issues.
  var orientations = UIInterfaceOrientationMask.portrait
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    get { return self.orientations }
    set { self.orientations = newValue }
  }

  // The app screen is white content on blue, so match the status bar.
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  let openSettingsColor = UIColor(red: 95.0/255.0, green: 66.0/255.0, blue: 65.0/255.0, alpha: 1.0)
  let switchLangColor = UIColor(red: 179.0/255.0, green: 98.0/255.0, blue: 85.0/255.0, alpha: 1.0)

  /// Sets the functionality of the button over the keyboard installation guide that opens Settings.
  func setSettingsBtn() {
    openSettingsBtn.setTitle("Open Settings", for: .normal)
    openSettingsBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    openSettingsBtn.setTitleColor(.white, for: .normal)
    openSettingsBtn.titleLabel?.font = UIFont(name: "Menlo", size: fontSize)

    openSettingsBtn.clipsToBounds = true
    openSettingsBtn.backgroundColor = openSettingsColor
    applyCornerRadius(elem: openSettingsBtn, radius: openSettingsBtn.frame.height * 0.1)

    openSettingsBtn.addTarget(self, action: #selector(openSettingsApp), for: .touchUpInside)
    openSettingsBtn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
  }
  
  /// Sets the functionality of the button that switches between installation instructions and the privacy policy.
  func setSwitchLangBtn() {
    switchLangBtn.setTitle("Language Mode: C++", for: .normal)
    switchLangBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    switchLangBtn.setTitleColor(.white, for: .normal)
    switchLangBtn.titleLabel?.font = UIFont(name: "Menlo", size: fontSize)

    switchLangBtn.clipsToBounds = true
    switchLangBtn.backgroundColor = switchLangColor
    applyCornerRadius(elem: switchLangBtn, radius: switchLangBtn.frame.height * 0.1)

    switchLangBtn.addTarget(self, action: #selector(showPopUpMenu), for: .touchUpInside)
    switchLangBtn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
  }

  /// Sets constant properties for the app screen.
  func setUIConstantProperties() {
    // Disable spacing views.
    let allSpacingViews: [UIView] = [topSpace, textGap, btnGap, bottomSpace]
    for view in allSpacingViews {
      view.isUserInteractionEnabled = false
      view.backgroundColor = .clear
    }
  }

  /// Sets properties for the app screen given the current device.
  func setUIDeviceProperties() {
    // Height ratios to set corner radii exactly.
//    let installTextToSwitchBtnHeightRatio = appTextBackground.frame.height / switchViewBackground.frame.height

    openSettingsBtn.clipsToBounds = true
    openSettingsBtn.layer.masksToBounds = false
//    settingsBtn.layer.cornerRadius = appTextBackground.frame.height * 0.4 / installTextToSwitchBtnHeightRatio

    // Disable text views.
    appTextView.isUserInteractionEnabled = false
    appTextView.backgroundColor = .clear
    appTextView.isEditable = false

    // Set link attributes for the textView.
    appTextView.linkTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor(.annotateBlue).light,
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ]
  }

  /// Sets the necessary properties for the installation UI including calling text generation functions.
  func setInstallationUI() {
    let settingsSymbol: UIImage = getSettingsSymbol(fontSize: fontSize)

    // Enable installation directions and GitHub notice elements.
    openSettingsBtn.isUserInteractionEnabled = true

    // Set the texts for the fields.
    appTextView.attributedText = setENInstallation(fontSize: fontSize)
    appTextView.textColor = .init(.keyChar).light
  }

  /// Creates the current app UI by applying constraints and calling child UI functions.
  func setCurrentUI() {
    // Set the font size and all button elements.
    setFontSize()
    setSwitchLangBtn()
    setSettingsBtn()
    setUIConstantProperties()
    setUIDeviceProperties()
    setInstallationUI()
  }

  /// Function to open the settings app that is targeted by settingsBtn.
  @objc func openSettingsApp() {
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
  }
  
  @objc func menuItemTapped() {
  }
  
  @objc func showPopUpMenu() {
    let item1 = UIMenuItem(title: "C++", action: #selector(menuItemTapped))
    let item2 = UIMenuItem(title: "JavaScript", action: #selector(menuItemTapped))
    let item3 = UIMenuItem(title: "Python", action: #selector(menuItemTapped))
    let item4 = UIMenuItem(title: "Java", action: #selector(menuItemTapped))
    let item5 = UIMenuItem(title: "Swift", action: #selector(menuItemTapped))
    // Create a UIMenuController and set the menu items
    let menuController = UIMenuController.shared
    menuController.menuItems = [item1, item2, item3, item4, item5]
    menuController.showMenu(from: switchLangBtn, rect: switchLangBtn.bounds)
  }

  /// Function to change the key coloration given a touch down.
  ///
  /// - Parameters
  ///  - sender: the button that has been pressed.
  @objc func keyTouchDown(_ sender: UIButton) {
//    if sender == switchLang {
//      sender.backgroundColor = .clear
//      sender.setTitleColor(switchViewColor, for: .normal)
//
//      // Bring sender's background and text colors back to their original values.
//      DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [self] in
//        sender.backgroundColor = switchViewColor
//        sender.setTitleColor(.init(.keyChar).light, for: .normal)
//      }
//    } else {
//      sender.backgroundColor = .black
//      sender.alpha = 0.2
//
//      // Bring sender's opacity back up to fully opaque and replace the background color.
//      DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//        sender.backgroundColor = .clear
//        sender.alpha = 1.0
//      }
//    }
  }
}
