//
//  ShowMoneyFormat.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/16.
//

import Foundation
import UIKit

//model
enum MoneyType {
    case money(Double)

    var text: String {
        switch self {
        case let .money(value):
            return String(format: "%.1f", abs(value))
        }
    }

    var color: UIColor {
        switch self {
        case let .money(int):
            if int > 0 {
                return .blue1()
            } else if int == 0 {
                return .g1()
            } else {
                return .red1()
            }
        }
    }

    var billTitle: String {
        switch self {
        case let .money(int):
            if int > 0 {
                return "Tack Back"
            } else if int == 0 {
                return "Balance"
            } else {
                return "To Pay"
            }
        }
    }

    var checkButtonTitle: String {
        switch self {
        case let .money(int):
            if int > 0 {
                return "還  款"
            } else if int == 0 {
                return ""
            } else {
                return "催  款"
            }
        }
    }
}
//
//struct UsersInfo {
//    var name: String
//    var image: UIImage
//}
