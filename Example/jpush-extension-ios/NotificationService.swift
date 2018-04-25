//
//  NotificationService.swift
//  jpush-extension-ios
//
//  Created by Antoine Cœur on 2018/4/24.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else {
            return
        }
        // Modify the notification content here.
        bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
        
        // if exist
        if let attachmentPath = bestAttemptContent.userInfo["my-attachment"] as? String,
            attachmentPath.hasSuffix("png"),
            let attachmentUrl = URL(string: attachmentPath) {
            // download
            let task = URLSession.shared.dataTask(with: attachmentUrl) { (data, response, error) in
                if let data = data {
                    let localPath = URL(fileURLWithPath: NSTemporaryDirectory() + "/myAttachment.png")
                    do {
                        try data.write(to: localPath, options: .atomic)
                        let attachment = try UNNotificationAttachment(identifier: "myAttachment", url: localPath)
                        bestAttemptContent.attachments = [attachment]
                    } catch {}
                }
                self.apnsDeliver(with: request)
            }
            task.resume()
        } else {
            apnsDeliver(with: request)
        }
    }
    
    func apnsDeliver(with request: UNNotificationRequest) {
        // please invoke this func on release version
        //JPushNotificationExtensionService.setLogOff()
        
        // service extension sdk
        // upload to calculate delivery rate
        // please set the same AppKey as your JPush
        JPushNotificationExtensionService.jpushSetAppkey("AppKey copied from JiGuang Portal application")
        JPushNotificationExtensionService.jpushReceive(request) {
            print("apns upload success")
            if let bestAttemptContent = self.bestAttemptContent {
                self.contentHandler?(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let bestAttemptContent = bestAttemptContent {
            contentHandler?(bestAttemptContent)
        }
    }
    
}
