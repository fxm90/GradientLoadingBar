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

        // Setup a counter, to validate closure is executed just once
        var observeOnceCount = 0
        notificationCenter.observeOnce(forName: notificationName) { (_: Notification)  in
            observeOnceCount += 1
        }

        // Setup a second counter, to validate all notifications have been send
        var addObserverCount = 0
        let observer = notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { (_: Notification) in
            addObserverCount += 1
        }

        // Trigger multiple notifications
        let notificationQuantity = 5
        let notificationDispatchQueue = DispatchQueue(label: "Queue sending notifications", qos: .userInitiated)
        notificationDispatchQueue.async {
            for _ in 1 ... notificationQuantity {
                self.notificationCenter.post(name: notificationName, object: nil)
            }
        }

        // Check counter after all notifications have been send
        let checkNotificationOffset: TimeInterval = 0.5
        let when = DispatchTime.now() + checkNotificationOffset
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.notificationCenter.removeObserver(observer)

            // Validate counters
            XCTAssertEqual(observeOnceCount, 1)
            XCTAssertEqual(addObserverCount, notificationQuantity)

            expect.fulfill()
        }

        wait(
            for: [expect],
            timeout: checkNotificationOffset + 0.1
        )
    }
}
