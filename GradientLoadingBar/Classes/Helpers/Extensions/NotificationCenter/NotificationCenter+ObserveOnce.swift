//
//  NotificationCenter+ObserveOnce.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 24.09.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import Foundation

// Source: https://gist.github.com/fxm90/68e2cc3cd6b63751c225b1e1249088cc
extension NotificationCenter {
    /// Adds an observer to the given notification center, which fires just once.
    ///
    /// Note:
    ///  - Same parameters as "addObserver", but with default properties
    ///    See http://apple.co/2zZIYJB for details.
    ///
    /// Parameters:
    ///  - name:   The name of the notification for which to register the observer
    ///  - object: The object whose notifications the observer wants to receive
    ///  - queue:  The operation queue to which block should be added.
    ///  - block:  The block to be executed when the notification is received.
    ///
    @discardableResult func observeOnce(forName name: NSNotification.Name?,
                                        object obj: Any? = nil,
                                        queue: OperationQueue? = nil,
                                        using block: @escaping (Notification) -> Swift.Void) -> NSObjectProtocol? {
        var observer: NSObjectProtocol?
        observer = addObserver(forName: name,
                               object: obj,
                               queue: queue) { [weak self] notification in
            defer {
                // Remove observer, so closure will be executed just once
                self?.removeObserver(observer!)
            }

            block(notification)
        }

        return observer
    }
}
