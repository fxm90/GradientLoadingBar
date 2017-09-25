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

    // Same parameters as "addObserver", except with default properties
    func observeOnce(
        forName: NSNotification.Name?,
        object obj: Any? = nil,
        queue: OperationQueue? = nil,
        using block: @escaping (Notification) -> Swift.Void)
    {
        var observer: NSObjectProtocol?
        observer = addObserver(
            forName: forName,
            object: obj,
            queue: queue
        ) { [weak self] (notification) in
            guard let `self` = self else {
                return
            }

            // Call completion block and..
            block(notification)

            // .. directly remove observer!
            self.removeObserver(observer!)
        }
    }
}
