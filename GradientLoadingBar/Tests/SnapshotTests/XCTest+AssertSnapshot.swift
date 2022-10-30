//
//  XCTest+AssertSnapshot.swift
//  ExampleSnapshotTests
//
//  Created by Felix Mau on 31.10.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI
import XCTest

/// Since version 1.10.0 the [Snapshot Testing library from Point Free](https://github.com/pointfreeco/swift-snapshot-testing/) dropped support
/// for CocoaPods. Therefore we use these helper methods, to avoid being dependent on an outdated version of the above mentioned library.
extension XCTest {

    // MARK: - Config

    private enum Config {
        static let snapshotDirectory = "__Snapshots__"
        static let defaultPrecision: Double = 1
    }

    // MARK: - Public methods

    @MainActor
    func assertSnapshot(matching swiftUIView: some View,
                        precision: Double = Config.defaultPrecision,
                        callFunction: String = #function,
                        callFilePath: String = #filePath,
                        file: StaticString = #file,
                        line: UInt = #line) {
        guard #available(iOS 16.0, *) else {
            XCTFail("`ImageRenderer` is only available in iOS 16.0 or newer. Make sure to use a corresponding device.", file: file, line: line)
            return
        }

        let renderer = ImageRenderer(content: swiftUIView)
        guard let image = renderer.uiImage else {
            XCTFail("Failed to get image from `ImageRenderer`.", file: file, line: line)
            return
        }

        assertSnapshot(matching: image,
                       precision: precision,
                       callFunction: callFunction,
                       callFilePath: callFilePath,
                       file: file,
                       line: line)
    }

    func assertSnapshot(matching viewController: UIViewController,
                        precision: Double = Config.defaultPrecision,
                        callFunction: String = #function,
                        callFilePath: String = #filePath,
                        file: StaticString = #file,
                        line: UInt = #line) {
        assertSnapshot(matching: viewController.view,
                       precision: precision,
                       callFunction: callFunction,
                       callFilePath: callFilePath,
                       file: file,
                       line: line)
    }

    func assertSnapshot(matching view: UIView,
                        precision: Double = Config.defaultPrecision,
                        callFunction: String = #function,
                        callFilePath: String = #filePath,
                        file: StaticString = #file,
                        line: UInt = #line) {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }

        assertSnapshot(matching: image,
                       precision: precision,
                       callFunction: callFunction,
                       callFilePath: callFilePath,
                       file: file,
                       line: line)
    }

    // MARK: - Private methods

    // swiftlint:disable:next function_parameter_count function_body_length cyclomatic_complexity
    private func assertSnapshot(matching image: UIImage,
                                precision: Double,
                                callFunction: String,
                                callFilePath: String,
                                file: StaticString,
                                line: UInt) {
        // E.g. "test_gradientActivityIndicatorView_shouldContainCorrectDefaultColors"
        let snapshotImageFileName = callFunction.trimmingCharacters(in: .alphanumerics.inverted)

        let unitTestFileURL = URL(fileURLWithPath: callFilePath)
        let snapshotImageFileURL = unitTestFileURL
            // Remove ".swift"
            .deletingLastPathComponent()
            // Append e.g. "__Snapshot__" directory
            .appendingPathComponent(Config.snapshotDirectory, isDirectory: true)
            // Append e.g. "test_gradientActivityIndicatorView_shouldContainCorrectDefaultColors"
            .appendingPathComponent(snapshotImageFileName, isDirectory: false)
            .appendingPathExtension("png")

        let snapshotFileManager = SnapshotFileManager(fileURL: snapshotImageFileURL)
        do {
            guard snapshotFileManager.hasReferenceImage() else {
                try snapshotFileManager.saveReferenceImage(image)
                XCTFail("Created reference image. Please run test again to verify the reference image.", file: file, line: line)
                return
            }

            let referenceImage = try snapshotFileManager.loadReferenceImage()

            let imageComparisonService = ImageComparisonService(lhsImage: referenceImage, rhsImage: image)
            let difference = try imageComparisonService.calculateDifference()

            // The above method `calculateDifference()` returns "0" for no difference and "1" for a complete difference.
            // The parameter `precision` defines "1" as totally equal images, therefore we subtract the differences from "1" here.
            let invertedDifference = 1 - difference
            XCTAssertGreaterThanOrEqual(invertedDifference, precision, file: file, line: line)
        } catch let error as SnapshotFileManager.LoadError {
            switch error {
            case let .failedToLoadFile(underlyingError):
                XCTFail("Failed to read snapshot reference file: `\(underlyingError)`.", file: file, line: line)

            case .failedToInstantiateImage:
                XCTFail("Failed to create reference image from file.", file: file, line: line)
            }
        } catch let error as ImageComparisonService.Error {
            switch error {
            case .invalidCoreImage:
                XCTFail("Failed to read property `cgImage` from image.", file: file, line: line)

            case .invalidDataProvider:
                XCTFail("Failed to read property `dataProvider` from core image.", file: file, line: line)

            case let .differentSize(lhsSize, rhsSize):
                XCTFail("Can't compare images due to different sizes: `\(lhsSize)` and `\(rhsSize)`.", file: file, line: line)
            }
        } catch let error as SnapshotFileManager.SaveError {
            switch error {
            case .invalidPNGData:
                XCTFail("Failed to create PNG data from image.", file: file, line: line)

            case let .failedToCreateDirectory(underlyingError):
                XCTFail("Failed to create snapshot directory: `\(underlyingError)`.", file: file, line: line)

            case .failedToWriteImage:
                XCTFail("Failed to write snapshot reference image.", file: file, line: line)
            }
        } catch {
            XCTFail("Unknown error `\(error)`.", file: file, line: line)
        }
    }
}

// MARK: - Supporting Types -

private final class SnapshotFileManager {

    // MARK: - Types

    enum SaveError: Swift.Error {
        case invalidPNGData
        case failedToCreateDirectory(underlyingError: Swift.Error)
        case failedToWriteImage
    }

    enum LoadError: Swift.Error {
        case failedToLoadFile(underlyingError: Error)
        case failedToInstantiateImage
    }

    // MARK: - Private properties

    private let fileManager: FileManager = .default
    private let fileURL: URL

    // MARK: - Instance Lifecycle

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    // MARK: - Public methods

    func hasReferenceImage() -> Bool {
        // We're using `.path` instead of `.absoluteString` here, to get rid of the "file://" prefix.
        fileManager.fileExists(atPath: fileURL.path)
    }

    func saveReferenceImage(_ image: UIImage) throws {
        let directory = fileURL.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: directory.absoluteString) {
            do {
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            } catch {
                throw SaveError.failedToCreateDirectory(underlyingError: error)
            }
        }

        guard let imagePNGData = image.pngData() else {
            throw SaveError.invalidPNGData
        }

        let isSuccess = fileManager.createFile(atPath: fileURL.path, contents: imagePNGData)
        if !isSuccess {
            throw SaveError.failedToWriteImage
        }
    }

    func loadReferenceImage() throws -> UIImage {
        do {
            let referenceImagePNGData = try Data(contentsOf: fileURL)
            guard let referenceImage = UIImage(data: referenceImagePNGData) else {
                throw LoadError.failedToInstantiateImage
            }

            return referenceImage
        } catch {
            throw LoadError.failedToLoadFile(underlyingError: error)
        }
    }
}

private final class ImageComparisonService {

    // MARK: - Types

    enum Error: Swift.Error {
        case invalidCoreImage
        case invalidDataProvider
        case differentSize(lhsSize: CGSize, rhsSize: CGSize)
    }

    private struct Pixel {
        // swiftlint:disable identifier_name
        let r: UInt8
        let g: UInt8
        let b: UInt8
        let a: UInt8
        // swiftlint:enable identifier_name

        /// Calculates the difference between the current instance and the given `rhsPixel` in percent.
        ///
        /// Returns:
        ///  - "0" if the `rhsPixel` has the **same color and alpha** values as the current instance.
        ///  - "1" if the `rhsPixel` has the **opposite color and alpha** values as the current instance.
        func difference(to rhsPixel: Pixel) -> Double {
            // We explicitly have to cast from `UInt8` to `Int` before subtracting the values,
            // as otherwise we could get a "arithmetic overflow" runtime failure for negative values.
            let absoluteDiffR = abs(Int(r) - Int(rhsPixel.r))
            let absoluteDiffG = abs(Int(g) - Int(rhsPixel.g))
            let absoluteDiffB = abs(Int(b) - Int(rhsPixel.b))
            let absoluteDiffA = abs(Int(a) - Int(rhsPixel.a))

            let percentageDiffR = (1.0 / 255) * Double(absoluteDiffR)
            let percentageDiffG = (1.0 / 255) * Double(absoluteDiffG)
            let percentageDiffB = (1.0 / 255) * Double(absoluteDiffB)
            let percentageDiffA = (1.0 / 255) * Double(absoluteDiffA)

            return (percentageDiffR + percentageDiffG + percentageDiffB + percentageDiffA) / 4
        }
    }

    // MARK: - Private properties

    private let lhsImage: UIImage
    private let rhsImage: UIImage

    // MARK: - Instance Lifecycle

    init(lhsImage: UIImage, rhsImage: UIImage) {
        self.lhsImage = lhsImage
        self.rhsImage = rhsImage
    }

    // MARK: - Public methods

    /// Calculates the difference between the given `lhsImage` and `rhsImage` in percent.
    ///
    /// Returns:
    ///  - "0" if `lhsImage` and `rhsImage` have the **same color and alpha** values.
    ///  - "1" if `lhsImage` and `rhsImage` have the **opposite color and alpha** values.
    func calculateDifference() throws -> Double {
        guard
            let lhsCGImage = lhsImage.cgImage,
            let rhsCGImage = rhsImage.cgImage
        else {
            throw Error.invalidCoreImage
        }

        guard
            let lhsDataProvider = lhsCGImage.dataProvider,
            let rhsDataProvider = rhsCGImage.dataProvider
        else {
            throw Error.invalidDataProvider
        }

        // We explicitly check for the width and height of the `CGImage` here.
        // > It's because `UIImage` has a scale property. This mediates between pixels and points. So, for example, a `UIImage` created
        // > from a "180x180" pixel image, but with a scale of "3", is automatically treated as having size 60x60 points. It will report
        // > its size as "60x60", and will also look good on a 3x resolution screen where 3 pixels correspond to 1 point.
        // https://stackoverflow.com/a/6488838
        guard lhsCGImage.size == rhsCGImage.size else {
            throw Error.differentSize(lhsSize: lhsImage.size, rhsSize: rhsImage.size)
        }

        let lhsPixelData = lhsDataProvider.data
        let lhsData: UnsafePointer<UInt8> = CFDataGetBytePtr(lhsPixelData)

        let rhsPixelData = rhsDataProvider.data
        let rhsData: UnsafePointer<UInt8> = CFDataGetBytePtr(rhsPixelData)

        let imageWidth = lhsCGImage.width
        let imageHeight = lhsCGImage.height

        var sumDifference = 0.0

        // swiftlint:disable identifier_name
        for x in 0 ..< imageWidth {
            for y in 0 ..< imageHeight {
                // swiftlint:enable identifier_name
                let pixelIndex = ((imageWidth * y) + x) * 4

                let lhsPixel = Pixel(r: lhsData[pixelIndex],
                                     g: lhsData[pixelIndex + 1],
                                     b: lhsData[pixelIndex + 2],
                                     a: lhsData[pixelIndex + 3])

                let rhsPixel = Pixel(r: rhsData[pixelIndex],
                                     g: rhsData[pixelIndex + 1],
                                     b: rhsData[pixelIndex + 2],
                                     a: rhsData[pixelIndex + 3])

                sumDifference += lhsPixel.difference(to: rhsPixel)
            }
        }

        let totalValues = imageWidth * imageHeight
        return sumDifference / Double(totalValues)
    }
}

// MARK: - Helper

private extension CGImage {

    var size: CGSize {
        CGSize(width: width, height: height)
    }
}
