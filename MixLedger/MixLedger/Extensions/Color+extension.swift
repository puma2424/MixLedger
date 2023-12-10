//
//  Color+extension.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/4.
//

import Foundation
import SwiftUI
import UIKit

// 顏色深 -> 淺：1 -> ...

extension Color {
    static let g1 = Color(red: 17 / 255, green: 54 / 255, blue: 29 / 255)
    static let g2 = Color(red: 178 / 255, green: 206 / 255, blue: 197 / 255)
    static let g3 = Color(red: 202 / 255, green: 232 / 255, blue: 220 / 255)

    static let mainG1 = Color(red: 17 / 255, green: 54 / 255, blue: 29 / 255)
    static let mainG2 = Color(red: 178 / 255, green: 206 / 255, blue: 197 / 255)
    static let mainG3 = Color(red: 202 / 255, green: 232 / 255, blue: 220 / 255)

    static let blue1 = Color(red: 91 / 255, green: 145 / 255, blue: 248 / 255)
    static let blue2 = Color(red: 189 / 255, green: 210 / 255, blue: 253 / 255)

    static let brightGreen1 = Color(red: 91 / 255, green: 217 / 255, blue: 165 / 255)
    static let brightGreen2 = Color(red: 95 / 255, green: 113 / 255, blue: 149 / 255)
    static let brightGreen3 = Color(red: 42 / 255, green: 154 / 255, blue: 153 / 255)
    static let brightGreen4 = Color(red: 171 / 255, green: 216 / 255, blue: 218 / 255)

    static let gray1 = Color(red: 94 / 255, green: 113 / 255, blue: 146 / 255)
    static let gray2 = Color(red: 194 / 255, green: 201 / 255, blue: 214 / 255)

    static let yellow1 = Color(red: 246 / 255, green: 189 / 255, blue: 21 / 255)
    static let yellow2 = Color(red: 249 / 255, green: 231 / 255, blue: 159 / 255)

    static let red1 = Color(red: 232 / 255, green: 105 / 255, blue: 75 / 255)
    static let red2 = Color(red: 245 / 255, green: 197 / 255, blue: 181 / 255)

    static let mint1 = Color(red: 110 / 255, green: 200 / 255, blue: 235 / 255)
    static let mint2 = Color(red: 190 / 255, green: 239 / 255, blue: 218 / 255)

    static let purple1 = Color(red: 183 / 255, green: 227 / 255, blue: 249 / 255)
    static let purple2 = Color(red: 167 / 255, green: 142 / 255, blue: 206 / 255)

    static let orange1 = Color(red: 254 / 255, green: 158 / 255, blue: 76 / 255)
    static let orange2 = Color(red: 254 / 255, green: 216 / 255, blue: 182 / 255)

    static let pink1 = Color(red: 245 / 255, green: 157 / 255, blue: 192 / 255)
    static let pink2 = Color(red: 254 / 255, green: 152 / 255, blue: 197 / 255)
}

extension UIColor {
    class func g1() -> UIColor {
        return UIColor(red: 17 / 255, green: 54 / 255, blue: 29 / 255, alpha: 1)
    }

    class func g2() -> UIColor {
        return UIColor(red: 178 / 255, green: 206 / 255, blue: 197 / 255, alpha: 1)
    }

    class func g3() -> UIColor {
        return UIColor(red: 202 / 255, green: 232 / 255, blue: 220 / 255, alpha: 1)
    }

    class func blue1() -> UIColor {
        return UIColor(red: 91 / 255, green: 145 / 255, blue: 249 / 255, alpha: 1)
    }

    class func blue2() -> UIColor {
        return UIColor(red: 189 / 255, green: 210 / 255, blue: 253 / 255, alpha: 1)
    }

    class func brightGreen1() -> UIColor {
        return UIColor(red: 90 / 255, green: 217 / 255, blue: 165 / 255, alpha: 1)
    }

    class func brightGreen2() -> UIColor {
        return UIColor(red: 190 / 255, green: 239 / 255, blue: 218 / 255, alpha: 1)
    }

    class func brightGreen3() -> UIColor {
        return UIColor(red: 37 / 255, green: 154 / 255, blue: 153 / 255, alpha: 1)
    }

    class func brightGreen4() -> UIColor {
        return UIColor(red: 185 / 255, green: 224 / 255, blue: 219 / 255, alpha: 1)
    }

    class func brightGreen5() -> UIColor {
        return UIColor(red: 171 / 255, green: 216 / 255, blue: 218 / 255, alpha: 1)
    }

    class func gray1() -> UIColor {
        return UIColor(red: 93 / 255, green: 113 / 255, blue: 145 / 255, alpha: 1)
    }

    class func gray2() -> UIColor {
        return UIColor(red: 194 / 255, green: 201 / 255, blue: 214 / 255, alpha: 1)
    }

    class func yellow1() -> UIColor {
        return UIColor(red: 247 / 255, green: 189 / 255, blue: 26 / 255, alpha: 1)
    }

    class func yellow2() -> UIColor {
        return UIColor(red: 251 / 255, green: 230 / 255, blue: 162 / 255, alpha: 1)
    }

    class func red1() -> UIColor {
        return UIColor(red: 234 / 255, green: 104 / 255, blue: 71 / 255, alpha: 1)
    }

    class func red2() -> UIColor {
        return UIColor(red: 243 / 255, green: 198 / 255, blue: 183 / 255, alpha: 1)
    }

    class func mint1() -> UIColor {
        return UIColor(red: 110 / 255, green: 200 / 255, blue: 233 / 255, alpha: 1)
    }

    class func mint2() -> UIColor {
        return UIColor(red: 190 / 255, green: 239 / 255, blue: 218 / 255, alpha: 1)
    }

    class func purple1() -> UIColor {
        return UIColor(red: 183 / 255, green: 227 / 255, blue: 249 / 255, alpha: 1)
    }

    class func purple2() -> UIColor {
        return UIColor(red: 167 / 255, green: 142 / 255, blue: 206 / 255, alpha: 1)
    }

    class func orange1() -> UIColor {
        return UIColor(red: 254 / 255, green: 158 / 255, blue: 76 / 255, alpha: 1)
    }

    class func orange2() -> UIColor {
        return UIColor(red: 254 / 255, green: 216 / 255, blue: 182 / 255, alpha: 1)
    }

    class func pink1() -> UIColor {
        return UIColor(red: 245 / 255, green: 157 / 255, blue: 192 / 255, alpha: 1)
    }

    class func pink2() -> UIColor {
        return UIColor(red: 254 / 255, green: 152 / 255, blue: 197 / 255, alpha: 1)
    }
}
