//
//  Extensions.swift
//  Coin Kurları
//
//  Created by Emre HAVAN on 21.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension Double {
    func yuvarla(basamak: Int) -> Double {
        let carpan = pow(10.0, Double(basamak))
        return (self*carpan).rounded()/carpan
    }
}

extension String {
    var doubleValue: Double {
        return Double(self) ?? 0
    }
}


extension String {
    static let numberFormatter = NumberFormatter()
    var formatValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
