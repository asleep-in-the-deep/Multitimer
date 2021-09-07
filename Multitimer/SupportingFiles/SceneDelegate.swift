//
//  SceneDelegate.swift
//  Multitimer
//
//  Created by Arina on 05.09.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let navController = UINavigationController()
            let viewController = ViewController()
            
            navController.viewControllers = [viewController]
            window.rootViewController = navController
            self.window = window
            
            window.makeKeyAndVisible()
        }
    }

}

