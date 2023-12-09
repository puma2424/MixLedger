//
//  ViewController.swift
//  testLocalNotifications
//
//  Created by 莊羚羊 on 2023/11/14.
//
import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 要求用戶授權接收通知
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // 授權成功，可以設定通知
                self.scheduleLocalNotification()
            } else {
                // 用戶未授權通知
                // 你可能想要在此處顯示提示或提醒用戶設置通知權限
            }
        }
    }

    func scheduleLocalNotification() {
        // 創建通知內容
        let content = UNMutableNotificationContent()
        content.title = "提醒記賬"
        content.body = "記得記錄今天的開支！"

        // 設置用戶指定的時間
        var dateComponents = DateComponents()
        dateComponents.hour = 15
        dateComponents.minute = 30

        // 創建每天固定時間觸發的通知
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // 創建通知請求
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)

        // 將通知請求添加到通知中心
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("無法安排通知：\(error.localizedDescription)")
            } else {
                print("通知已安排成功")
            }
        }
    }
}
