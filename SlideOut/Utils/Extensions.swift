//
//  Extensions.swift
//  SlideOut
//
//  Created by Kim Nordin on 2022-10-02.
//

import Foundation
import UIKit

extension UIColor {
    public func named(_ name: String) -> UIColor? {
        let allColors: [String: UIColor] = [
            "red": .red,
            "green": .green,
            "yellow": .yellow,
            "blue": .blue,
            "orange": .orange,
            "purple": .purple
        ]
        let cleanedName = name.replacingOccurrences(of: " ", with: "").lowercased()
        return allColors[cleanedName]
    }
}
