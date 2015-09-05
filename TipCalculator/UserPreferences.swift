//
//  UserPreferences.swift
//  TipCalculator
//
//  Created by Marcel Molina on 9/3/15.
//  Copyright © 2015 Marcel Molina. All rights reserved.
//

import Foundation

struct UserPreferences {
  let defaults: NSUserDefaults
  
  let LocaleKey = "preferred_locale"
  let PreviousBill = "previous_bill"
  let PreviousBillDate = "previous_bill_date"
  static let DefaultBill = 0.0
  
  enum TipPercentageKey: String {
    case LowTip
    case MediumTip
    case HighTip
  }
  
  enum DefaultTip: Int {
    case Low    = 18
    case Medium = 20
    case High   = 22
  }
  
  var previousBill: Double {
    get {
      return defaults.valueForKey(PreviousBill) as? Double ?? UserPreferences.DefaultBill
    }
    
    set {
      previousBillDate = NSDate.timeIntervalSinceReferenceDate()
      defaults.setDouble(newValue, forKey: PreviousBill)
    }
  }
  
  var previousBillDate: NSTimeInterval {
    get {
      return defaults.valueForKey(PreviousBillDate) as? Double ?? 0.0
    }
    
    set {
      defaults.setDouble(newValue, forKey: PreviousBillDate)
    }
  }
  
  var preferredLocale: String {
    get {
      return defaults.valueForKey(
        LocaleKey
      ) as? String ?? NSLocale.currentLocale().localeIdentifier
    }
    
    set {
      defaults.setObject(newValue, forKey: LocaleKey)
    }
  }
  
  var lowTipPercentage: Int {
    get {
      return defaults.valueForKey(
        TipPercentageKey.LowTip.rawValue
      ) as? Int ?? DefaultTip.Low.rawValue
    }
    
    set {
      defaults.setInteger(newValue, forKey: TipPercentageKey.LowTip.rawValue)
    }
  }
  
  var mediumTipPercentage: Int {
    get {
      return defaults.valueForKey(
        TipPercentageKey.MediumTip.rawValue
        ) as? Int ?? DefaultTip.Medium.rawValue
    }
    
    set {
      defaults.setInteger(newValue, forKey: TipPercentageKey.MediumTip.rawValue)
    }
  }
  
  var highTipPercentage: Int {
    get {
      return defaults.valueForKey(
        TipPercentageKey.HighTip.rawValue
        ) as? Int ?? DefaultTip.High.rawValue
    }
    
    set {
      defaults.setInteger(newValue, forKey: TipPercentageKey.HighTip.rawValue)
    }
  }
  
  init() {
    self.defaults = NSUserDefaults.standardUserDefaults()
  }
  
  func defaultTipPercentages() -> [Int] {
    return [lowTipPercentage, mediumTipPercentage, highTipPercentage]
  }
  
  func billWasEnteredRecently() -> Bool {
    let now = NSDate.timeIntervalSinceReferenceDate()
    return (now - previousBillDate) < (10 * 60) // Ten minutes
  }
  
  func save() {
    print("Saving preferences: \(defaultTipPercentages())")
    
    defaults.synchronize()
  }
}