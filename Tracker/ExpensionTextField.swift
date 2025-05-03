//
//  ExpensionTextField.swift
//  Tracker
//
//  Created by Maxim on 23.04.2025.
//

import UIKit

extension UITextField {
    func setIndents(){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        self.leftView = view
        self.leftViewMode = .always
        self.rightView = view
        self.rightViewMode = .never
    }
    
}
