//
//  SceneDelegate.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    static var shared: SceneDelegate {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("Unable to access SceneDelegate instance.")
        }
        return sceneDelegate
    }

    var sceneWindow: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        guard let window = window else { return }
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window.windowScene = windowScene
        window.backgroundColor = UIColor(named: "G3")
        window.makeKeyAndVisible()
        sceneWindow = window
//        FirebaseAuthenticationManager.checkUserAuthenticationState { result in
//            switch result {
//            case true:
//                guard let userID = FirebaseAuthenticationManager.shared.currentUser?.uid else {
//                    ShowScreenManager.showSinginScreen(window: window)
//                    return
//                }
//                SaveData.shared.myID = userID
//                ShowScreenManager.showMainScreen(window: window)
//                guard let url = connectionOptions.urlContexts.first?.url
//                    else { return }
//                UrlRouteManager.open(url: url)
//
//            case false:
//                ShowScreenManager.showSinginScreen(window: window)
//            }
//        }
        ShowScreenManager.showMainScreen(window: window)
    }

    // 当应用程序通过 URL 被打开时调用
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let window = window else { return }
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window.windowScene = windowScene
        window.backgroundColor = UIColor(named: "G3")
        window.makeKeyAndVisible()
        sceneWindow = window
        FirebaseAuthenticationManager.checkUserAuthenticationState { result in
            switch result {
            case true:
                guard let userID = FirebaseAuthenticationManager.shared.currentUser?.uid else {
                    ShowScreenManager.showSinginScreen(window: window)
                    return
                }
                SaveData.shared.myID = userID
                ShowScreenManager.showMainScreen(window: window)

                // 尝试使用 UrlRouteManager 处理打开的 URL 上下文
                guard let url = URLContexts.first?.url else { return }
                UrlRouteManager.open(url: url)

            case false:
                ShowScreenManager.showSinginScreen(window: window)
            }
        }
    }

    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
