//
//  ShowMoneyFormat.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/16.
//

import Foundation
import UIKit

enum MoneyType {
    case money(Double)

    var text: String {
        switch self {
        case let .money(int):
            return String(int)
        }
    }

    var color: UIColor {
        switch self {
        case let .money(int):
            if int > 0 {
                return UIColor.blue
            } else {
                return UIColor.red
            }
        }
    }
    
    var billTitle: String{
        switch self {
        case let .money(int):
            if int > 0 {
                return "待還款"
            } else {
                return "待收款"
            }
        }
    }
    
    var checkButtonTitle: String{
        switch self {
        case let .money(int):
            if int < 0 {
                return "還款"
            } else {
                return "催款"
            }
        }
    }
}

struct UsersInfo {
    var name: String
    var image: UIImage
}
