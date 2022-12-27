//
//  KeyboardStyling.swift
//
//  Functions to style keyboard elements.
//

import UIKit

/// Styles a button including it's shape and text.
///
/// - Parameters
///  - btn: the button to be styled.
///  - title: the title to be assigned.
///  - radius: the corner radius of the button.
func styleBtn(btn: UIButton, title: String, radius: CGFloat) {
  btn.clipsToBounds = true
  btn.layer.masksToBounds = false
  btn.layer.cornerRadius = radius
  btn.setTitle(title, for: .normal)
  btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
  btn.setTitleColor(keyCharColor, for: .normal)

  if title != "Scribe" {
    btn.layer.shadowColor = keyShadowColor
    btn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    btn.layer.shadowOpacity = 1.0
    btn.layer.shadowRadius = 0.0
  }
}

// The names of symbols whose keys should be slightly larger than the default size.
var keysThatAreSlightlyLarger: [String] = [
  "delete.left",
  "shift",
  "shift.fill",
  "capslock.fill",
  "arrowtriangle.right.fill"
]

/// Get the icon configurations for keys if the device is an iPhone.
///
/// - Parameters
///  - iconName: the name of the UIImage systemName icon to be used.
func getPhoneIconConfig(iconName: String) -> UIImage.SymbolConfiguration {
  var iconConfig = UIImage.SymbolConfiguration(
    pointSize: letterKeyWidth / 1.75,
    weight: .light,
    scale: .medium
  )
  if keysThatAreSlightlyLarger.contains(iconName) {
    iconConfig = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 1.55,
      weight: .light,
      scale: .medium
    )
  }
  if isLandscapeView == true {
    iconConfig = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 3.5,
      weight: .light,
      scale: .medium
    )
    if keysThatAreSlightlyLarger.contains(iconName) {
      iconConfig = UIImage.SymbolConfiguration(
        pointSize: letterKeyWidth / 3.2,
        weight: .light,
        scale: .medium
      )
    }
  }
  return iconConfig
}

/// Styles buttons that have icon keys.
///
/// - Parameters
///  - btn: the button to be styled.
///  - color: the tint color for the icon on the key.
///  - iconName: the name of the UIImage systemName icon to be used.
func styleIconBtn(btn: UIButton, color: UIColor, iconName: String) {
  btn.setTitle("", for: .normal)
  let iconConfig = getPhoneIconConfig(iconName: iconName)

  btn.setImage(UIImage(systemName: iconName, withConfiguration: iconConfig), for: .normal)
  btn.tintColor = color
}

/// Sets icon of delete button for pressed or non-pressed state.
/// - Parameters:
///   - button: The delete button.
///   - isPressed: Determines if icon for pressed or non-pressed state will be set.
func styleDeleteButton(_ button: UIButton, isPressed: Bool) {
  if commandState == .idle {
    styleIconBtn(btn: button, color: keyCharColor,
                 iconName: isPressed ? "delete.left.fill" : "delete.left")
  } else {
    styleIconBtn(btn: button, color: keyCharColor,
                 iconName: isPressed ? "xmark.circle.fill" : "xmark.circle")
  }
}
