//
//  AppDelegate.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import KYDrawerController
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        showFirstController()
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyBGSAUhiZ7hlffCv7FnHou2Q4klOO6AOkQ")
        GMSPlacesClient.provideAPIKey("AIzaSyBGSAUhiZ7hlffCv7FnHou2Q4klOO6AOkQ")
        GIDSignIn.sharedInstance().clientID = "730913208094-kd59g77garastu984l6u2ufqq31sps3o.apps.googleusercontent.com"
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

extension AppDelegate {
    private func showFirstController() {
        if User.shared.token == "" || User.shared.token == nil {
            showLoginScreen()
        } else {
            showHomeScreen()
        }
    }
    
    private func showLoginScreen() {
        let loginViewController = LoginCoordinator.createLoginViewController()
        let nav = UINavigationController(rootViewController: loginViewController)
        nav.isNavigationBarHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    private func showHomeScreen() {
        let width = UIScreen.main.bounds.width - 50
        let mainViewController   = HomeCoordinator.createHomeViewController()
        let drawerViewController = SideMenuCoordinator.createSideMenuViewController()
        let drawerController     = KYDrawerController(drawerDirection: .left,
                                                      drawerWidth: width)
        drawerController.mainViewController = UINavigationController(
            rootViewController: mainViewController
        )
        drawerController.drawerViewController = drawerViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = drawerController
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    
}
