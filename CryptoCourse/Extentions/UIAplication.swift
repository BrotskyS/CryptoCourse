//
//  UIAplication.swift
//  CryptoCourse
//
//  Created by Sergiy Brotsky on 09.06.2022.
//

import Foundation
import SwiftUI


extension UIApplication {
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
