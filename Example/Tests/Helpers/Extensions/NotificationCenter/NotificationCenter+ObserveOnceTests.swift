//
//  NotificationCenter+ObserveOnceTests.swift
//  GradientLoadingBarTests
//
//  Created by Felix Mau on 30.10.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import XCTest
@testable import GradientLoadingBar

class NotificationCenterObserveOnceTests: XCTestCase {
    var notificationCenter: NotificationCenter!

    override func setUp() {
        super.setUp()

        notificationCenter = NotificationCenter()
    }

    override func tearDown() {
        notificationCenter = nil

        super.tearDown()
    }

    func testNotificationReceived() {
        let expect = expectation(description: "Should receive notification")

        let notificationName = Notification.Name(rawValue: "foobar")
        notificationCenter.observeOnce(forName: notificationName) { (_: Notification)  in
            expect.fulfill()
        }

        notificationCenter.post(name: notificationName, object: nil)
        wait(
            for: [expect],
            timeout: TimeInterval(0.1)
        )
    }

    func testNotificationReceivedJustOnce() {
        let expect = expectation(description: "Should receive notification just once")

        let notificationName = Notification.Name(rawValue: "foobar")
        var notificationCount = 0
        notificationCenter.observeOnce(forName: notificationName) { (_: Notification)  in
            notificationCount += 1
        }

        // Trigger multiple notifications
        let notificationDispatchQueue = DispatchQueue(label: "Queue sending notifications", qos: .userInitiated)
        notificationDispatchQueue.async {
            for _ in 1...4 {
                self.notificationCenter.post(name: notificationName, object: nil)
            }
        }

        // Check counter after all notifications have been send
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            XCTAssertEqual(notificationCount, 1)

            expect.fulfill()
        }

        wait(
            for: [expect],
            timeout: TimeInterval(0.6)
        )
    }
}
