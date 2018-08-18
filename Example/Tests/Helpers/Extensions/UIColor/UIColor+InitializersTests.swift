//
//  UIColor+InitializersTests.swift
//  GradientLoadingBarTests
//
//  Created by Felix Mau on 26.08.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

@testable import GradientLoadingBar
import XCTest

class UIColorInitializersTests: XCTestCase {
    func testColorFromAbsoluteRGB() {
        let red = 10
        let green = 20
        let blue = 30

        let color = UIColor(absoluteRed: red,
                            green: green,
                            blue: blue)

        guard let absoluteRGBA = color.absoluteRGBA else {
            XCTFail("Expected to have valid color components at this point.")
            return
        }

        XCTAssertEqual(absoluteRGBA.red, red)
        XCTAssertEqual(absoluteRGBA.green, green)
        XCTAssertEqual(absoluteRGBA.blue, blue)
        XCTAssertEqual(absoluteRGBA.alpha, 255)
    }

    func testColorFromAbsoluteRGBA() {
        let red = 50
        let green = 100
        let blue = 150
        let alpha = 200

        let color = UIColor(absoluteRed: red,
                            green: green,
                            blue: blue,
                            alpha: alpha)

        guard let absoluteRGBA = color.absoluteRGBA else {
            XCTFail("Expected to have valid color components at this point.")
            return
        }

        XCTAssertEqual(absoluteRGBA.red, red)
        XCTAssertEqual(absoluteRGBA.green, green)
        XCTAssertEqual(absoluteRGBA.blue, blue)
        XCTAssertEqual(absoluteRGBA.alpha, alpha)
    }

    func testColorFromHexInteger() {
        let color = UIColor(hex: 0x007AFF)
        guard let absoluteRGBA = color.absoluteRGBA else {
            XCTFail("Expected to have valid color components at this point.")
            return
        }

        XCTAssertEqual(absoluteRGBA.red, 0)
        XCTAssertEqual(absoluteRGBA.green, 122)
        XCTAssertEqual(absoluteRGBA.blue, 255)
        XCTAssertEqual(absoluteRGBA.alpha, 255)
    }

    func testColorFromHexString() {
        let red = "00"
        let green = "7a"
        let blue = "ff"

        let color = UIColor(hex: "\(red)\(green)\(blue)")
        guard let absoluteRGBA = color.absoluteRGBA else {
            XCTFail("Expected to have valid color components at this point.")
            return
        }

        XCTAssertEqual(absoluteRGBA.red, red.asHexadecimalNumber)
        XCTAssertEqual(absoluteRGBA.green, green.asHexadecimalNumber)
        XCTAssertEqual(absoluteRGBA.blue, blue.asHexadecimalNumber)
        XCTAssertEqual(absoluteRGBA.alpha, 255)
    }

    func testColorFromHexStringWithPrefixedHash() {
        let red = "00"
        let green = "7a"
        let blue = "ff"

        let color = UIColor(hex: "#\(red)\(green)\(blue)")
        guard let absoluteRGBA = color.absoluteRGBA else {
            XCTFail("Expected to have valid color components at this point.")
            return
        }

        XCTAssertEqual(absoluteRGBA.red, red.asHexadecimalNumber)
        XCTAssertEqual(absoluteRGBA.green, green.asHexadecimalNumber)
        XCTAssertEqual(absoluteRGBA.blue, blue.asHexadecimalNumber)
        XCTAssertEqual(absoluteRGBA.alpha, 255)
    }
}

// MARK: - Helper: Get absolute RGBA values.

fileprivate extension UIColor {
    struct AbsoluteRGBA {
        let red: Int
        let green: Int
        let blue: Int
        let alpha: Int
    }

    var absoluteRGBA: AbsoluteRGBA? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        return AbsoluteRGBA(red: Int(red * 255.0),
                            green: Int(green * 255.0),
                            blue: Int(blue * 255.0),
                            alpha: Int(alpha * 255.0))
    }
}

// MARK: - Helper: Convert hex number as string to integer.

fileprivate extension String {
    var asHexadecimalNumber: Int? {
        return Int(self, radix: 16)
    }
}
