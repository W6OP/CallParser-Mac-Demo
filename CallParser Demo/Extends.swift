//
//  Extensions.swift
//  CallParser
//
//  Created by Peter Bourget on 8/22/20.
//  Copyright © 2020 Peter Bourget. All rights reserved.
//

import Foundation

// MARK: - Array Extension ----------------------------------------------------------------------------

// great but a little slow
extension Array where Element: Equatable {
    func all(where predicate: (Element) -> Bool) -> [Element]  {
        return self.compactMap { predicate($0) ? $0 : nil }
    }
}

// MARK: - String Protocol Extensions

// also look at https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
// https://stackoverflow.com/questions/32305891/index-of-a-substring-in-a-string-with-swift
// https://rbnsn.me/multi-core-array-operations-in-swift
// https://medium.com/better-programming/24-swift-extensions-for-cleaner-code-41e250c9c4c3

/// For string slices
extension StringProtocol where Index == String.Index {
  //let end = mask.endIndex(of: "]")!
  func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
    range(of: string, options: options)?.upperBound
  }
}

// MARK: - String Extensions

// https://www.agnosticdev.com/content/how-get-first-or-last-characters-string-swift-4
// Build your own String Extension for grabbing a character at a specific position
// usage if let character = str.character(at: 3)
// nil returned if value to large for string
extension String {

  func index(at position: Int, from start: Index? = nil) -> Index? {
    let startingIndex = start ?? startIndex
    return index(startingIndex, offsetBy: position, limitedBy: endIndex)
  }

  func character(at position: Int) -> String? {
    guard position >= 0 && position <= self.count - 1, let indexPosition = index(at: position) else {
      return nil
    }
    return String(self[indexPosition])
  }

  // ----------------------

      var length: Int {
          return count
      }

      subscript (i: Int) -> String {
          return self[i ..< i + 1]
      }

      func substring(fromIndex: Int) -> String {
          return self[min(fromIndex, length) ..< length]
      }

      func substring(toIndex: Int) -> String {
          return self[0 ..< max(0, toIndex)]
      }

      subscript (r: Range<Int>) -> String {
          let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                              upper: min(length, max(0, r.upperBound))))
          let start = index(startIndex, offsetBy: range.lowerBound)
          let end = index(start, offsetBy: range.upperBound - range.lowerBound)
          return String(self[start ..< end])
      }

  // in some cases these may be preferable to those above
  // allows to use simple Ints for subscripting strings

//  subscript (i: Int) -> Character {
//      return self[index(startIndex, offsetBy: i)]
//  }
//
//  subscript (bounds: CountableRange<Int>) -> Substring {
//      let start = index(startIndex, offsetBy: bounds.lowerBound)
//      let end = index(startIndex, offsetBy: bounds.upperBound)
//      if end < start { return "" }
//      return self[start..<end]
//  }
//
//  subscript (bounds: CountableClosedRange<Int>) -> Substring {
//      let start = index(startIndex, offsetBy: bounds.lowerBound)
//      let end = index(startIndex, offsetBy: bounds.upperBound)
//      if end < start { return "" }
//      return self[start...end]
//  }
//
//  subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
//      let start = index(startIndex, offsetBy: bounds.lowerBound)
//      let end = index(endIndex, offsetBy: -1)
//      if end < start { return "" }
//      return self[start...end]
//  }
//
//  subscript (bounds: PartialRangeThrough<Int>) -> Substring {
//      let end = index(startIndex, offsetBy: bounds.upperBound)
//      if end < startIndex { return "" }
//      return self[startIndex...end]
//  }
//
//  subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
//      let end = index(startIndex, offsetBy: bounds.upperBound)
//      if end < startIndex { return "" }
//      return self[startIndex..<end]
//  }
 // ------------------------------------------------------------------

  /// trim string - remove spaces and other similar symbols (for example, new lines and tabs)
  var trimmed: String {
      self.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  mutating func trim() {
      self = self.trimmed
  }
  // ------------------------------------------------------------------
  // get date from string
  func toDate(format: String) -> Date? {
      let df = DateFormatter()
      df.dateFormat = format
      return df.date(from: self)
  }
  // ------------------------------------------------------------------

  // test if a character is an int
  var isInteger: Bool {
    return Int(self) != nil
  }

  var isNumeric: Bool {
    guard self.count > 0 else { return false }
    let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    return Set(self).isSubset(of: nums)
  }

  var containsOnlyDigits: Bool {
      let notDigits = NSCharacterSet.decimalDigits.inverted
      return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
  }

  var isAlphabetic: Bool {
    guard self.count > 0 else { return false }
    let alphas: Set<Character> = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    return Set(self).isSubset(of: alphas)
  }

  func isAlphanumeric() -> Bool {
    return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
  }

//  var isAlphanumeric: Bool {
//      !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
//  }

  // ------------------------------------------------------------------
  // here to end
  // https://stackoverflow.com/questions/29971505/filter-non-digits-from-string
  var onlyDigits: String { return onlyCharacters(charSets: [.decimalDigits]) }
  var onlyLetters: String { return onlyCharacters(charSets: [.letters]) }

  private func filterCharacters(unicodeScalarsFilter closure: (UnicodeScalar) -> Bool) -> String {
    return String(String.UnicodeScalarView(unicodeScalars.filter { closure($0) }))
  }

  private func filterCharacters(definedIn charSets: [CharacterSet], unicodeScalarsFilter: (CharacterSet, UnicodeScalar) -> Bool) -> String {
    if charSets.isEmpty { return self }
    let charSet = charSets.reduce(CharacterSet()) { return $0.union($1) }
    return filterCharacters { unicodeScalarsFilter(charSet, $0) }
  }

  func removeCharacters(charSets: [CharacterSet]) -> String { return filterCharacters(definedIn: charSets) { !$0.contains($1) } }
  func removeCharacters(charSet: CharacterSet) -> String { return removeCharacters(charSets: [charSet]) }

  func onlyCharacters(charSets: [CharacterSet]) -> String { return filterCharacters(definedIn: charSets) { $0.contains($1) } }
  func onlyCharacters(charSet: CharacterSet) -> String { return onlyCharacters(charSets: [charSet]) }
}

// MARK: - Extension Collection ----------------------------------------------------------------------------

// if the digit is the next in value 5,6 = true
extension Int {
  func isSuccessor(first: Int, second: Int) -> Bool {
    if second - first == 1 {
      return true
    }
    return false
  }

  func toDouble() -> Double {
      Double(self)
  }

  func toString() -> String {
      "\(self)"
  }
}

extension Double {
    func toInt() -> Int {
        Int(self)
    }

  func toString() -> String {
      String(format: "%.02f", self)
  }
}

// get string from date
extension Date {
    func toString(format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}

//  allows to get the app version from Info.plist
// let appVersion = Bundle.mainAppVersion
extension Bundle {
    var appVersion: String? {
        self.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    static var mainAppVersion: String? {
        Bundle.main.appVersion
    }
}

//public class PrefixFileParser2: ObservableObject {
//
//  /**
//   Expand the masks by expanding the meta characters (@#?) and the groups [1-7]
//   */
//  func expandMask(element: String) -> [[String]] {
//    var primaryMaskList = [[String]]()
//
//    let mask = element.trimmingCharacters(in: .whitespacesAndNewlines)
//
//    var position = 0
//    let offset = mask.startIndex
//
//      while position < mask.count {
//        // determine if the first character is a "[" [JT][019]
//        if mask[mask.index(offset, offsetBy: position)] == "[" {
//            let start = mask.index(offset, offsetBy: position)
//          let remainder = mask[mask.index(offset, offsetBy: position)..<mask.endIndex]
//            let end = remainder.endIndex(of: "]")!
//            let substring = mask[start..<end]
//            // [JT]
//            primaryMaskList.append(expandGroup(group: String(substring)))
//            for _ in substring {
//              position += 1
//            }
//        } else {
//          let char = mask[mask.index(offset, offsetBy: position)] //mask[position]
//          let subItem = expandMetaCharacters(mask: String(char))
//          let subArray = subItem.map { String($0) }
//          primaryMaskList.append(subArray)
//          position += 1
//        }
//      }
//
//    return primaryMaskList
//  }
//
//  /**
//   L[1-9O-W]#[DE]
//   take individual characters until [ is hit
//   get everything between [ and ]
//   take first character until - is hit
//
//   */
//  func expandGroup(group: String) -> [String]{
//
//    var maskList = [String]()
//
//    let groupArray = group.components(separatedBy: CharacterSet(charactersIn: "[]")).filter({ $0 != ""})
//
//    for group in groupArray {
//      var index = 0
//      var previous = ""
//      // array of String[L] : String[1, -, 9, O, -, W] : String[#] : String[D,E]
//      var maskCharacters = group.map { String($0) }
//      let count = maskCharacters.count
//      while (index < count) { // subElementArray.count
//        let maskCharacter = maskCharacters[0]
//        switch maskCharacter{
//        case "#", "@", "?":
//          let subItem = expandMetaCharacters(mask: group)
//          let subArray = subItem.map { String($0) }
//          maskList.append(contentsOf: subArray)
//          index += 1
//        case "-":
//          let first = previous //subElementArray.before("-")!
//          let second = maskCharacters.after("-")!
//          let subArray = expandRange(first: String(first), second: String(second))
//          maskList.append(contentsOf: subArray)
//          index += 3
//          maskCharacters.removeFirst(2) // remove first two chars !!!
//          if maskCharacters.count > 1 {
//            maskList.append(maskCharacters[0])
//            previous = maskCharacters[0]
//            maskCharacters.removeFirst()
//          }
//        default:
//          //maskList.append(contentsOf: [String](arrayLiteral: group))
//          maskList.append(maskCharacter)
//          previous = maskCharacters[0]
//          maskCharacters.removeFirst()
//          index += 1
//        }
//      }
//    }
//
//    return maskList
//  }
//
//  func expandGroupOld(group: String) -> [String]{
//
//    var maskList = [String]()
//
//    let groupArray = group.components(separatedBy: CharacterSet(charactersIn: "[]")).filter({ $0 != ""})
//
//
//    for element in groupArray {
//      var index = 0
//      var previous = ""
//      // array of String[L] : String[1, -, 9, O, -, W] : String[#] : String[D,E]
//      var subElementArray = element.map { String($0) }
//      let count = subElementArray.count
//      while (index < count) { // subElementArray.count
//        let subElement = subElementArray[0]
//        switch subElement{
//        case "#", "@", "?":
//          let subItem = expandMetaCharacters(mask: element)
//          let subArray = subItem.map { String($0) }
//          maskList.append(contentsOf: subArray)
//          index += 1
//        case "-":
//          let first = previous //subElementArray.before("-")!
//          let second = subElementArray.after("-")!
//          let subArray = expandRange(first: String(first), second: String(second))
//          maskList.append(contentsOf: subArray)
//          index += 3
//          break
//        default:
//          maskList.append(contentsOf: [String](arrayLiteral: element))
//          index += 1
//        }
//
//        previous = subElementArray[0]
//        subElementArray.removeFirst()
//      }
//    }
//
//    return maskList
//  }
//
//  /**
//   Replace meta characters with the strings they represent.
//   No point in doing if # exists as strings are very short.
//   # = digits, @ = alphas and ? = alphas and numerics
//   -parameters:
//   -String:
//   */
//  func expandMetaCharacters(mask: String) -> String {
//
//    var expandedCharacters: String
//
//    expandedCharacters = mask.replacingOccurrences(of: "#", with: "0123456789")
//    expandedCharacters = expandedCharacters.replacingOccurrences(of: "@", with: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
//    expandedCharacters = expandedCharacters.replacingOccurrences(of: "?", with: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
//
//    return expandedCharacters
//  }
//
//  /// Expand
//   func expandRange(first: String, second: String) -> [String] {
//
//    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
//    var expando = [String]()
//
//    // 1-5
//    if first.isInteger && second.isInteger {
//      if let firstInteger = Int(first) {
//        if let secondInteger = Int(second) {
//          let intArray: [Int] = Array(firstInteger...secondInteger)
//          expando = intArray.dropFirst().map { String($0) }
//        }
//      }
//    }
//
//    // 0-C - NOT TESTED
//    if first.isInteger && second.isAlphabetic {
//      if let firstInteger = Int(first){
//          let range: Range<String.Index> = alphabet.range(of: second)!
//          let index: Int = alphabet.distance(from: alphabet.startIndex, to: range.lowerBound)
//
//        let _: [Int] = Array(firstInteger...9)
//          //let myRange: ClosedRange = 0...index
//
//        for item in alphabet[0..<index] {
//          expando.append(String(item))
//          print (item)
//        }
//
//      }
//    }
//
//    // W-3 - NOT TESTED
//    if first.isAlphabetic && second.isInteger {
//      if let secondInteger = Int(second){
//          let range: Range<String.Index> = alphabet.range(of: first)!
//          let index: Int = alphabet.distance(from: alphabet.startIndex, to: range.upperBound)
//
//        let _: [Int] = Array(0...secondInteger)
//        //let myRange: ClosedRange = index...25
//
//        for item in alphabet[index..<25] {
//          expando.append(String(item))
//          print (item)
//        }
//
//      }
//    }
//
//    // A-G
//    if first.isAlphabetic && second.isAlphabetic {
//
//      let range: Range<String.Index> = alphabet.range(of: first)!
//      let index: Int = alphabet.distance(from: alphabet.startIndex, to: range.lowerBound)
//
//      let range2: Range<String.Index> = alphabet.range(of: second)!
//      let index2: Int = alphabet.distance(from: alphabet.startIndex, to: range2.upperBound)
//
//      //let myRange: ClosedRange = index...index2
//
//      for item in alphabet[index..<index2] {
//        expando.append(String(item))
//      }
//
//      // the first character has already been stored
//      expando.remove(at: 0)
//    }
//    //print("\(first):\(second):\(expando)")
//
//    return expando
//  }
//}

extension BidirectionalCollection where Iterator.Element: Equatable {
    typealias Element = Self.Iterator.Element

    func after(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = self.firstIndex(of: item) {
            let lastItem: Bool = (index(after:itemIndex) == endIndex)
            if loop && lastItem {
                return self.first
            } else if lastItem {
                return nil
            } else {
                return self[index(after:itemIndex)]
            }
        }
        return nil
    }

    func before(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = self.firstIndex(of: item) {
            let firstItem: Bool = (itemIndex == startIndex)
            if loop && firstItem {
                return self.last
            } else if firstItem {
                return nil
            } else {
                return self[index(before:itemIndex)]
            }
        }
        return nil
    }
}

/*
 private List<string[]> ExpandMask(string mask)
        {
            string maskPart;
            int counter = 0;
            int index;
            string expandedMask = "";
            string maskCharacter;
            string[] metaCharacters = { "@", "#", "?", "-", "." };

            // sometimes "-" has spaces around it [1 - 8]
            mask = string.Concat(mask.Where(c => !char.IsWhiteSpace(c)));

            mask = "L[1-9O-W]#[DE]";

            int length = mask.Length;

            while (counter < length)
            {
                maskCharacter = mask.Substring(0, 1);
                switch (maskCharacter)
                {
                    case "[": // range
                        index = mask.IndexOf("]");
                        maskPart = mask.Substring(0, index + 1);
                        counter += maskPart.Length;
                        mask = mask.Substring(maskPart.Length);
                        // look for expando in the set
                        if (metaCharacters.Any(maskPart.Contains))
                        {
                            maskPart = string.Join("", GetMetaMaskSet(maskPart));
                        }
                        expandedMask += maskPart;
                        break;
                    case "@": // alpha
                        // use constant for performance
                        expandedMask += "[@]";
                        counter += 1;
                        if (counter < length)
                        {
                            mask = mask.Substring(1);
                        }
                        break;
                    case "#": // numeric
                        expandedMask += "[#]";
                        counter += 1;
                        if (counter < length)
                        {
                            mask = mask.Substring(1);
                        }
                        break;
                    case "?": // alphanumeric
                        expandedMask += "[?]";
                        counter += 1;
                        if (counter < length)
                        {
                            mask = mask.Substring(1);
                        }
                        break;

                    case ".":
                        expandedMask += ".";
                        counter += 1;
                        if (counter < length)
                        {
                            mask = mask.Substring(1);
                        }
                        break;

                    default: // single character
                        expandedMask += maskCharacter.ToString();
                        counter += 1;
                        if (counter < length)
                        {
                            mask = mask.Substring(1);
                        }
                        break;
                }
            }

            return CombineComponents(expandedMask);
        }
 */
