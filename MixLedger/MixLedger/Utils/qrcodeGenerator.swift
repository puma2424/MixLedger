//
//  qrcodeGenerator.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/22.
//

import Foundation
import CoreImage

func createQRCodeForString(_ text: String, size: CGSize) -> CIImage? {
    // 將文字資料轉換成Data
    let data = text.data(using: .isoLatin1)
    // 用CIFilter轉換，
    // 我們需要做的是建立新的 CoreImage 濾波器（利用 CIQRCodeGenerator ）來指定一些參數，
    // 然後即可獲得輸出的圖片，也就是 QR Code 圖片。
    let qrFilter = CIFilter(name: "CIQRCodeGenerator")
    // 這是要轉換成 QR Code 圖片的初始資料
    qrFilter?.setValue(data, forKey: "inputMessage")

    // 設定生成的圖片大小
    let scaleX = size.width / (qrFilter?.outputImage?.extent.width ?? 1.0)
    let scaleY = size.height / (qrFilter?.outputImage?.extent.height ?? 1.0)
    let transformedImage = qrFilter?.outputImage?.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
    // 將取出的校正等級設定進去
    qrFilter?.setValue("M", forKey: "inputCorrectionLevel")

//        let qrImage = UIImage(ciImage: transformedImage)
    return transformedImage
}
