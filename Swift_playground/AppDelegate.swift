//
//  AppDelegate.swift
//  Swift_playground
//
//  Created by yesdgq on 2017/5/11.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.configCocoaLumberjack()
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        if let window = window {
//            // make window visible
//            window.rootViewController = ViewController()
//            window.backgroundColor = UIColor(red: 70/255, green: 154/255, blue: 233/255, alpha: 1)
//            window.makeKeyAndVisible()
//        }
        
       
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Swift_playground")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


// 封装的日志输出功能（T表示不指定日志信息参数类型）
func DONG_Log<T>(_ message: T, file: String = #file, function: String = #function,
                 line:Int = #line) {
    #if DEBUG
        // 获取文件名
        let fileName = (file as NSString).lastPathComponent
        // 打印日志内容
        print("\(fileName) 🔴 第\(line)行：\(message)")
    #endif
}

extension AppDelegate {
    
    func configCocoaLumberjack() {
        
//        DDLog.add(DDOSLogger.sharedInstance, with: .verbose)    // Uses os_log
//        DDLog.add(DDASLLogger.sharedInstance, with: .warning)
        DDLog.add(DDTTYLogger.sharedInstance, with: .verbose)   // xcode控制台
    
        DDTTYLogger.sharedInstance.logFormatter = MyDDLogFormatter.sharedInstance()
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)[0]
        let logfileManager = DDLogFileManagerDefault(logsDirectory: documentsDirectory)
        let fileLogger: DDFileLogger = DDFileLogger(logFileManager: logfileManager)
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        
        
        DDLogVerbose("Verbose")
        DDLogDebug("Debug")
        DDLogInfo("Info")
        DDLogWarn("Warn")
        DDLogError("Error")
    }
    
}

