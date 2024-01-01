# MixLedger
AppWorks School #22 iOS,Personal Project

## Summary

為了滿足多人共同出遊或室友共享開支的需求，因此開發出 MixLedger ，這是一個可以與他人共享帳本並輕鬆結算金額的記帳 APP 。

## Table of Contents
- [Features](#features)
    - [Home](#home)
    - [分享帳本](#分享帳本)
    - [新增帳目](#新增帳目)
    - [帳款狀態](#帳款狀態)
    - [訊息](#訊息)
    - [圖表](#charts)
- [Library](#libraries)
- [安裝說明](#安裝說明)
- [與我聯絡](#與我聯絡)

## Features
### Home 

共享帳本和個人帳本的首頁。

共享帳本可以進行[分享](#分享帳本)，並查看[帳款狀態](#帳款狀態)。

<img src="https://github.com/puma2424/MixLedger/assets/141214046/15c653d6-eb35-427d-9af4-f1637d2f4f0b" alt="hom2" width="200"/>  <img src="https://github.com/puma2424/MixLedger/assets/141214046/6e106337-4755-4b2b-a448-329ccfc3dd28" alt="home1" width="200"/>

### 分享帳本

可以使用 QRCode 、傳送連結和直接搜尋其他用戶名字等方式邀請他人加入帳本。

<img src="https://github.com/puma2424/MixLedger/assets/141214046/400ec2a9-a480-4fde-b589-555c907ddf65" alt="shareAccount" width="200"/>


### 新增帳目
    
- 發票掃描：
    
     以 Swift 原生的 Vision 解析畫面上的 QRCode ，解析資料後再將內容做處理取得發票內容。

     <img src="https://github.com/puma2424/MixLedger/assets/141214046/5a4d1b5f-eeb6-44e3-a757-e15272101483" alt="ScanInvoice" width="200"/>
    
- 分配金額

    可以輸入於其他共享者如何分配支出的金額。

    <img src="https://github.com/puma2424/MixLedger/assets/141214046/54364fcd-7e31-49cc-86e1-27598e6e5509" alt="DistributionAmount" width="200"/>

### 帳款狀態

在共享帳本中，可以查看與其他共享者的帳款狀態，並且進行還款或催款。
- 催款
    
    點擊後將發送訊息請對方還款。

    <img src="https://github.com/puma2424/MixLedger/assets/141214046/6bb4c330-07b9-4946-a37b-4ddd710512a6" alt="chartPie" width="200"/>

- 還款
    
    若其他共享者在訊息中確認還款，將會在付款者、接受者的個人帳本以及共享帳本中，同步更新資料。

    <img src="https://github.com/puma2424/MixLedger/assets/141214046/59e28556-fc01-4208-9685-6d315b466383" alt="repay" width="200"/>

### 訊息

用戶可以在訊息頁面中，看到共享帳本的邀請和確認還款的訊息。

<img src="https://github.com/puma2424/MixLedger/assets/141214046/60d86047-f613-4235-9392-4bb6777d2ec6" alt="chartPie" width="200"/>
    

### Charts
不同圖表讓支出狀況更清楚。
1. SwiftUI 畫出圓餅圖。
2. 運用 SeiftUI 的新框架 Charts 畫出直方圖。


- 圓餅圖
    
    <img src="https://github.com/puma2424/MixLedger/assets/141214046/d39ec9bf-8714-4453-9019-8d3e206af6c7" alt="chartPie" width="200"/>
    
- 直方圖
    
    <img src="https://github.com/puma2424/MixLedger/assets/141214046/22ea9140-9b81-422f-ad8b-2be940d5e5bd" alt="chartBox" width="200"/>

## Libraries
1. **Firebase:**
   - Firebase是一個全面的移動應用程式開發平台，提供各種服務，包括實時數據庫、身份驗證、雲端存儲等。在這個項目中，Firebase被用於雲端儲存和身份驗證。

2. **SnapKit:**
   - SnapKit是一種用於Auto Layout的第三方套件，使在iOS應用程式的用戶界面中定義和管理約束更加容易。

3. **JGProgressHUD:**
   - JGProgressHUD是一個多功能且可自定義的iOS應用程式中的HUD（Heads Up Display）。它在專案中用於顯示 loading、success、failure 等訊息。

4. **IQKeyboardManagerSwift:**
   - IQKeyboardManagerSwift是一個用於處理iOS應用程式中鍵盤的Swift庫。它提供功能，如自動管理鍵盤的顯示和隱藏，防止與鍵盤相關的UI問題。

這些第三方套件已經被整合到專案中，除 Firebase 其他皆用使用 Cocoapods 做管理。因 Firebase 使用 Cocoapods 下載時存在一些問題，因此 Firebase 是用 Swift Package Manager 做下載與管理。

## 安裝說明

下載後若想在使用 **測試帳號** 在模擬器上運行，將 code 更改為以下。

``` swift
// SceneDelegate.swift

func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
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
```

```swift 
// SaveData.swift

//    var myID = ""
    var myID = "bGzuwR00sPRNmBamK91D" // test
```

下載後若想在使用 **真實帳號** 在模擬器上運行，將 code 更改為以下。

``` swift
// SceneDelegate.swift

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
        FirebaseAuthenticationManager.checkUserAuthenticationState { result in
            switch result {
            case true:
                guard let userID = FirebaseAuthenticationManager.shared.currentUser?.uid else {
                    ShowScreenManager.showSinginScreen(window: window)
                    return
                }
                SaveData.shared.myID = userID
                ShowScreenManager.showMainScreen(window: window)
                guard let url = connectionOptions.urlContexts.first?.url
                    else { return }
                UrlRouteManager.open(url: url)

            case false:
                ShowScreenManager.showSinginScreen(window: window)
            }
        }
//        ShowScreenManager.showMainScreen(window: window)
    }
```

```swift 
// SaveData.swift

    var myID = ""
//  var myID = "bGzuwR00sPRNmBamK91D" // test
```

## 與我聯絡
作者：WenYu Chuang(Puma)

e-mail: cwenyu2424@gmail.com

若有任何疑問或建議都歡迎透過以上方式與我聯絡。
