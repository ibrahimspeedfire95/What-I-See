//
//  AppDelegate.swift
//  What I See
//
//  Created by ibrahim al-khatib on 2/18/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        CoreDataController.sharedController
//        
//        RecognizedUser.addRecognizedUser()
//        let rus = RecognizedUser.getRecognizedUsers()
//        print(rus)
//                
        listenVolumeButton()
        return true
    }

    func listenVolumeButton() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
        } catch {
            print("some error")
        }
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.window?.insertSubview(MPVolumeView(), at: 0)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            print("got in here")
            
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let identifyFacesvc = storyBoard.instantiateViewController(withIdentifier: "IdentifyFacesViewController")
            
            var vc = window?.rootViewController
            while vc?.presentedViewController != nil{
                vc = vc?.presentedViewController
            }
            
            if !(vc is IdentifyFacesViewController) {
                vc?.present(identifyFacesvc, animated: true, completion: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TakePicture"), object: nil)
            }
            
        }
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
    }

    // MARK: Core Date
    
}


