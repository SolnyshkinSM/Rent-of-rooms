//
//  SceneDelegate.swift
//  Rent of rooms
//
//  Created by Administrator on 02.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        #warning("DEBUG")
        #if DEBUG
        
        self.window?.rootViewController = getCurrentTabBarController()
        
        #endif
        
        loadImageMusic()
        fillInDemoData()        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}

