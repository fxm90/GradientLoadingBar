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
        let notificationName = Notification.Name(rawValue: "foobar?_=\(Date().timeIntervalSince1970)")

        var receivedNotificationName: Notification.Name?
        notificationCenter.observeOnce(forName: notificationName) { (receivedNotification: Notification)  in
            receivedNotificationName = receivedNotification.name
        }

        notificationCenter.post(name: notificationName, object: nil)

        XCTAssertNotNil(receivedNotificationName, "Expected to have a valid `receivedNotificationName` in at this point")
        XCTAssertEqual(receivedNotificationName!, notificationName)
    }

    func testNotificationReceivedJustOnce() {
        let notificationName = Notification.Name(rawValue: "foobar?_=\(Date().timeIntervalSince1970)")

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
        for _ in 1 ... notificationQuantity {
            self.notificationCenter.post(name: notificationName, object: nil)
        }

        // Validate counters
        XCTAssertEqual(observeOnceCount, 1)
        XCTAssertEqual(addObserverCount, notificationQuantity)

        self.notificationCenter.removeObserver(observer)
    }

    func testClosureShouldNotBeTriggeredIfObserverRemovedManually() {
        let notificationName = Notification.Name(rawValue: "foobar?_=\(Date().timeIntervalSince1970)")

        var receivedNotificationName: Notification.Name?
        let observer = notificationCenter.observeOnce(forName: notificationName) { (receivedNotification: Notification)  in
            receivedNotificationName = receivedNotification.name
        }

        XCTAssertNotNil(observer, "Expected to have a valid `observer` in at this point")
        notificationCenter.removeObserver(observer!)

        notificationCenter.post(name: notificationName, object: nil)

        XCTAssertNil(receivedNotificationName)
    }
}
