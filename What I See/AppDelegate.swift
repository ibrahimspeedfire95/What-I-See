//
//  AppDelegate.swift
//  What I See
//
//  Created by ibrahim al-khatib on 2/18/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var managedObjectContext: NSManagedObjectContext! {
        get {
            let coordinator = self.persistentStoreCoordinator
            if coordinator == nil {
                return nil
            }
            
            let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            return managedObjectContext
        }
    }
    
    var managedObjectModel: NSManagedObjectModel! {
        get {
            let modelURL = Bundle.main.url(forResource: "FaceSdkSample", withExtension: "momd")
            return NSManagedObjectModel(contentsOf: modelURL!)
        }
    }
    
    var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        get {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            let storeURL = self.applicationDocumentsDirectory().appendingPathComponent("FaceSdkSample.sqlite")
            
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                return persistentStoreCoordinator
            } catch {
                let dic = [
                    NSLocalizedDescriptionKey : "Failed to initialize the application's saved data",
                    NSLocalizedFailureReasonErrorKey : "There was an error creating or loading the application's saved data.",
                    NSUnderlyingErrorKey : error ] as [String : Any]
                let error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dic)
                print("Unresolved error \(error) \(error.userInfo)")
                abort()
            }
            return nil
        }
    }
    
    var mdl: Data!
    var recomdl: Data!
    var jdaDetector: intptr_t!
    var recognizer: intptr_t!
    
    var groups: Array<Any>!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        jdaDetector = 0
        groups = []
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
        self.saveContext()
    }

    // MARK: Core Date
    
    func applicationDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
    func saveContext() {
        let managedObjectContext = self.managedObjectContext
        if managedObjectContext != nil {
            if (managedObjectContext?.hasChanges)! {
                do {
                    try managedObjectContext?.save()
                } catch  {
                    abort()
                }
            }
        }
    }

}
















































