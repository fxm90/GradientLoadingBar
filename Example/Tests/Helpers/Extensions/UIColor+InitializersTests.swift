//
//  UIColor+InitializersTests.swift
//  GradientLoadingBarTests
//
//  Created by Felix Mau on 26.08.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import XCTest
@testable import GradientLoadingBar

class UIColorInitializersTests: XCTestCase {

    func testColorFromAbsoluteRGB() {
        let red = 10
        let green = 20
        let blue = 30

        let color = UIColor(absoluteRed: red, green: green, blue: blue)
        if let colorValues = color.absoluteRGBA() {
            XCTAssertEqual(colorValues.red, red)
            XCTAssertEqual(colorValues.green, green)
            XCTAssertEqual(colorValues.blue, blue)
            XCTAssertEqual(colorValues.alpha, 255)
        } else {
            XCTFail("Could not get \"absoluteRGB()\" from color.")
        }
    }

    func testColorFromAbsoluteRGBA() {
        let red = 50
        let green = 100
        let blue = 150
        let alpha = 200

        let color = UIColor(absoluteRed: red, green: green, blue: blue, alpha: alpha)
        if let colorValues = color.absoluteRGBA() {
            XCTAssertEqual(colorValues.red, red)
            XCTAssertEqual(colorValues.green, green)
            XCTAssertEqual(colorValues.blue, blue)
            XCTAssertEqual(colorValues.alpha, alpha)
        } else {
            XCTFail("Could not get \"absoluteRGB()\" from color.")
        }
    }

    func testColorFromHex() {
        let color = UIColor(hex: 0x007AFF)

        if let colorValues = color.absoluteRGBA() {
            XCTAssertEqual(colorValues.red, 0)
            XCTAssertEqual(colorValues.green, 122)
            XCTAssertEqual(colorValues.blue, 255)
            XCTAssertEqual(colorValues.alpha, 255)
        } else {
            XCTFail("Could not get \"absoluteRGB()\" from color.")
        }
    }

    func testColorFromHexString() {
        let red = "00"
        let green = "7a"
        let blue = "ff"

        let hexString = "\(red)\(green)\(blue)"
        let color = UIColor(hexString: hexString)

        if let colorValues = color.absoluteRGBA() {
            XCTAssertEqual(colorValues.red, red.hexToDec())
            XCTAssertEqual(colorValues.green, green.hexToDec())
            XCTAssertEqual(colorValues.blue, blue.hexToDec())
            XCTAssertEqual(colorValues.alpha, 255)
        } else {
            XCTFail("Could not get \"absoluteRGB()\" from color.")
        }
    }

    func testColorFromHexStringWithPrefixedHash() {
        let red = "00"
        let green = "7a"
        let blue = "ff"

        let hexString = "#\(red)\(green)\(blue)"
        let color = UIColor(hexString: hexString)

        if let colorValues = color.absoluteRGBA() {
            XCTAssertEqual(colorValues.red, red.hexToDec())
            XCTAssertEqual(colorValues.green, green.hexToDec())
            XCTAssertEqual(colorValues.blue, blue.hexToDec())
            XCTAssertEqual(colorValues.alpha, 255)
        } else {
            XCTFail("Could not get \"absoluteRGB()\" from color.")
        }
    }
}

// MARK: - Helper to get absolute RGBA values.

fileprivate extension UIColor {
    struct AbsoluteRGBA {
        let red: Int
        let green: Int
        let blue: Int
        let alpha: Int
    }

    func absoluteRGBA() -> AbsoluteRGBA? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        return AbsoluteRGBA(
            red: Int(red * 255.0),
            green: Int(green * 255.0),
            blue: Int(blue * 255.0),
            alpha: Int(alpha * 255.0)
        )
    }
}

// MARK: - Helper to convert hex number as string to integer.

fileprivate extension String {
    func hexToDec() -> Int? {
        return Int(self, radix: 16)
    }
}
