//
//  ViewController.swift
//  TipCalculator
//
//  Created by Marcel Molina on 9/3/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import UIKit

@IBDesignable class ViewController: UIViewController {
  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var billField: UITextField!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var tipControl: UISegmentedControl!
  @IBOutlet weak var localeControl: UISegmentedControl!
  
  @IBOutlet weak var leftFace: UIImageView!
  @IBOutlet weak var rightFace: UIImageView!
  @IBOutlet weak var middleFace: UIImageView!
  
  var faces: [UIImageView] {
    return [leftFace, middleFace, rightFace]
  }
  
  let selectedFaceAlpha   = CGFloat(1.0)
  let deselectedFaceAlpha = CGFloat(0.25)
  
  let defaultTipAmount = 0.2
  let availableLocales = [
    NSLocale(localeIdentifier: "en_US"),
    NSLocale(localeIdentifier: "en_UK")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    billField.becomeFirstResponder()
    updateFaces()
    updateDefaultTipValues()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    print("View will appear")
    updateDefaultTipValues()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func onTap(sender: AnyObject) {
    view.endEditing(true)
  }
  
  @IBAction func onEditingChanged(sender: AnyObject) {
    updateFaces()
    
    if let billAmount = billAsDouble() {
      let tip   = billAmount * tipPercentage()
      let total = billAmount + tip
      
      tipLabel.text   = formatCurrency(tip)
      totalLabel.text = formatCurrency(total)
    } else {
      print("TODO: handle invalid value")
    }
  }
  
  func updateFaces() {
    for (index, face) in faces.enumerate() {
      if tipControl.selectedSegmentIndex == index {
        face.alpha = selectedFaceAlpha
      } else {
        face.alpha = deselectedFaceAlpha
      }
    }
  }
  
  func updateDefaultTipValues() {
    let userPreferences = UserPreferences()
    
    for (index, defaultTipAmount) in userPreferences.defaultTipPercentages().enumerate() {
      tipControl.setTitle(String(defaultTipAmount) + "%", forSegmentAtIndex: index)
    }
  }
  
  // MARK: - Input validation/normalization
  
  private func billAsDouble() -> Double? {
    return billField.text.map {
      ($0 as NSString).doubleValue
    }
  }
  
  private func tipPercentage() -> Double {
    let selectedIndex = tipControl.selectedSegmentIndex
    return tipControl.titleForSegmentAtIndex(selectedIndex).map { amount in
      return convertPercentageStringToDouble(amount)
    } ?? defaultTipAmount
  }
  
  private func convertPercentageStringToDouble(percentageString: String) -> Double {
    let arrayOfNumbers  = percentageString.characters.flatMap { Int(String($0)) }
    let stringOfNumbers = arrayOfNumbers.map(String.init).joinWithSeparator("") as NSString
    
    return stringOfNumbers.doubleValue / 100.0
  }
  
  private func formatCurrency(amount: Double) -> String {
    let currencyFormatter = NSNumberFormatter()
    currencyFormatter.locale = availableLocales[localeControl.selectedSegmentIndex]
    currencyFormatter.maximumFractionDigits = 2
    currencyFormatter.minimumFractionDigits = 2
    currencyFormatter.alwaysShowsDecimalSeparator = false
    currencyFormatter.numberStyle = .CurrencyStyle
    return currencyFormatter.stringFromNumber(amount)!
  }
}