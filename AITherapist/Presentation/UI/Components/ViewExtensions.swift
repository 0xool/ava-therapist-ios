//
//  ViewExtensions.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/18/23.
//

import Foundation
import SwiftUI



extension UIViewController {
  func screen() -> UIScreen? {
    var parent = self.parent
    var lastParent = parent
    
    while parent != nil {
      lastParent = parent
      parent = parent!.parent
    }
    
    return lastParent?.view.window?.windowScene?.screen
  }
}
