//
//  CommandVariables.swift
//
//  Variables associated with Scribe commands.
//

import UIKit

// Basic keyboard functionality variables.
var capsLockPossible = false
var doubleSpacePeriodPossible = false
var autoAction1Visible: Bool = true
var backspaceTimer: Timer?
var scribeKeyHeight = CGFloat(0)

// All data needed for Scribe commands for the given language keyboard.
let autosuggestions = loadJSON(filename: "autosuggestions")

// Words that should not be included in autocomplete should be added to the string below.
var autocompleteWords = [String]()
var baseAutosuggestions = [String]()
var numericAutosuggestions = [String]()
var pronounAutosuggestionTenses: [String: String] = [:]
var verbsAfterPronounsArray = [String]()

var currentPrefix: String = ""
var pastStringInTextProxy: String = ""
var completionWords = [String]()

// A larger vertical bar than the normal | key for the cursor.
let commandCursor: String = "│"
var commandPromptSpacing: String = ""

// Command input and output variables.
var inputWordIsCapitalized: Bool = false
var wordToReturn: String = ""
var invalidCommandMsg: String = ""

// Annotation variables.
var annotationState: Bool = false
var activateAnnotationBtn: Bool = false
var prepAnnotationForm: String = ""
var annotationBtns: [UIButton] = [UIButton]()
var annotationColors: [UIColor] = [UIColor]()
var annotationSeparators: [UIView] = [UIView]()
var annotationDisplayWord: String = ""
var wordToCheck: String = ""
var wordsTyped: [String] = [String]()
var annotationsToAssign: [String] = [String]()
