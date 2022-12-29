//
//  ENAppText.swift
//
//  The English app text for the Scribe app.
//

import UIKit

/// Formats and returns the title of the installation guidelines.
func getENInstallationTitle(fontSize: CGFloat) -> NSMutableAttributedString {
  return NSMutableAttributedString(string: """
  {
  
  """, attributes: [NSAttributedString.Key.font: UIFont(name: "Menlo", size: fontSize)!])
}

/// Formats and returns the directions of the installation guidelines.
func getENInstallationDirections(fontSize: CGFloat) -> NSMutableAttributedString {

  let startOfBody = NSMutableAttributedString(string: """
    Key: Board,
    Description:
      A keyboard for quick
      code editing on mobile
      devices,
    Tags:
    [
      Programmers,
      DX,
      Coding,
    ],
    Settings:
    {
      1: Open Settings,
      2: General,
      3: KeyBoard,
      4: Keyboards,
      5: Add New Keyboard,
    }
    Language: C++,
  }
  """, attributes: [NSAttributedString.Key.font: UIFont(name: "Menlo", size: fontSize)!])
  
  let att = NSMutableParagraphStyle()
  att.lineSpacing = 7.0
  startOfBody.addAttribute(NSAttributedString.Key.paragraphStyle, value: att, range: NSRange(location: 0, length: startOfBody.length))

  return startOfBody
}

/// Formats and returns the full text for the installation guidelines.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func setENInstallation(fontSize: CGFloat) -> NSMutableAttributedString {
  let installTitle = getENInstallationTitle(fontSize: fontSize)
  let installDirections = getENInstallationDirections(fontSize: fontSize)

  return concatAttributedStrings(
    left: installTitle,
    right: installDirections
  )
}
