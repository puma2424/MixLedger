//
//  JGProgressHUDWrapper.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/2.
//

import JGProgressHUD

enum HUDType {
    case success(String)
    case failure(String)
}

class LKProgressHUD {
    static let shared = LKProgressHUD()

    private init() {}

    let hud = JGProgressHUD(style: .dark)

    var view: UIView {
        if let window = SceneDelegate.shared.window,
           let rootViewController = window.rootViewController
        {
            return rootViewController.view
        }
        return UIView()
        
    }

    static func show(type: HUDType) {
        switch type {
        case let .success(text):
            showSuccess(text: text)
        case let .failure(text):
            showFailure(text: text)
        }
    }

    static func showSuccess(inView: UIView = shared.view, text: String = "success") {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showSuccess(text: text)
            }
            return
        }
        shared.hud.textLabel.text = text
        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        shared.hud.show(in: inView)
        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func showFailure(inView: UIView = shared.view, text: String = "Failure") {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showFailure(text: text)
            }
            return
        }
        shared.hud.textLabel.text = text
        shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        shared.hud.show(in: inView)
        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func show(inView: UIView = shared.view) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                show()
            }
            return
        }
        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        shared.hud.textLabel.text = "Loading"
        shared.hud.show(in: inView)
    }

    static func dismiss() {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                dismiss()
            }
            return
        }
        shared.hud.dismiss()
    }
}
