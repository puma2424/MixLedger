//
//  ScanInvoiceManager.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/25.
//

import Foundation
import UIKit
import Vision

enum ChineseEncodingParameter: Int {
    case big5 = 0
    case utf8 = 1
    case base64 = 2
    
    var encodingParameter: String {
        switch self {
        case .big5:
            return "Big5"
        case .utf8:
            return "UTF-8"
        case .base64:
            return "Base64"
        }
    }
}

struct ProductInfo {
    var name: String
    var quantity: Int
    var price: Double
}

class ScanInvoiceManager {
    
    static let shared = ScanInvoiceManager()
    
    var invoiceString: [String] = []
    
    var invoiceNumber: String = ""
    
    var invoiceDateString: String = ""
    
    var invoiceDate: Date = Date()
    
    var invoiceRandomNumber: String = ""
    
    var invoiceTotalAmount: String = ""
    
    var invoiceOfChineseEncodingParameter: ChineseEncodingParameter?
    
    var productDetails: [ProductInfo] = []
    
    enum ResultForm {
        case formQRCode([String])
        case formText([String])
    }
    
    func imageToText(_ imageParameter: UIImage, completion: @escaping (Result<ResultForm, Error>) -> Void) {
        
        let barcodeDetectionRequest = VNDetectBarcodesRequest()
        barcodeDetectionRequest.symbologies = [.qr, .ean13, .code39]
        
        let textRecognitionRequest = VNRecognizeTextRequest()
        textRecognitionRequest.recognitionLanguages = ["zh-Hant", "en-US"]
        
        if let image = imageParameter.cgImage {
            let handler = VNImageRequestHandler(cgImage: image)
            
            DispatchQueue.global().async {
                do {
                    try handler.perform([barcodeDetectionRequest, textRecognitionRequest])
                    
                    if let barcodeResults = barcodeDetectionRequest.results as? [VNBarcodeObservation] {
                        var results: [String] = []
                        for observation in barcodeResults {
                            results.append("--Barcode Detection Result--")
                            if let content = observation.payloadStringValue {
                                results.append(content)
                            }
                        }
                        completion(.success(.formQRCode(results)))
                    }
                    if let textResults = textRecognitionRequest.results as? [VNRecognizedTextObservation] {
                        var results: [String] = []
                        results.append("--Text Recognition Result--")
                        print(results)
                        
                        for observation in textResults {
                            if let textString = observation.topCandidates(1).first?.string {
                                
                                results.append(textString)
                            }
                        }
                        completion(.success(.formText(results)))
                        
                    }
                } catch {
                    print("Error during recognition: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func displayBarcodeResults(view: AddNewItemViewController, selectedImage: UIImage, completion: @escaping (Result<ResultForm, Error>) -> Void) {
        
        do {
            
            try? imageToText(selectedImage){result in
                
                DispatchQueue.main.async {
                    switch result{
                        
                    case .success(let from):
                        switch from{
                        case .formQRCode(let result):
                            self.processInvoiceInfo(invioiceText: result){
                                completion(.success(.formQRCode([])))
                            }
                        case .formText(let result):
                            print(result)
                            self.processInvoiceInfo(invioiceText: result){
                                completion(.success(.formText([])))
                            }
                        }
                        if self.invoiceNumber == ""{
                            self.takePhotoAgain(view: view)
                        }
                    case .failure(let error):
                        print(error)
                        self.takePhotoAgain(view: view)
                    }
                }
            }
            
        } catch {
            print("解碼時發生錯誤: \(error)")
            
            
        }
        
    }
    
    func processInvoiceInfo(invioiceText: [String], completion: @escaping () -> ()){
        productDetails = []
        invoiceNumber = ""
        invoiceDateString = ""
        invoiceRandomNumber = ""
        invoiceTotalAmount = ""
        
        for text in invioiceText{
            if text.contains("==") {
                guard var range = text.range(of: "==") else {return}
                let mainInfo = String(text.prefix(upTo: range.lowerBound))
                invoiceNumber =  String(mainInfo.prefix(10))
                
                var dateString = String(mainInfo.prefix(10 + 7).suffix(7))
                if var dateInt = Int(dateString){
                    dateInt += 19110000
                    dateString = "\(dateInt)"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"
                    let date = dateFormatter.date(from: dateString)
                    invoiceDate = date ?? Date()
                }
                invoiceDateString = dateString
                
                invoiceRandomNumber = String(mainInfo.prefix(10 + 7 + 4).suffix(4))
                
                //金額被以16進位記載
                let totalAmount = String(mainInfo.prefix(10 + 7 + 4 + 16).suffix(8))
                var intValue: UInt32 = 0
                if Scanner(string: totalAmount).scanHexInt32(&intValue){
                    invoiceTotalAmount = "\(intValue)"
                }
                //                    var invoiceOfChineseEncodingParameter: ChineseEncodingParameter?
                
                if let productsRange = text.range(of: "==:"){
                    let details = String(text.suffix(from: productsRange.upperBound))
                    var product = details.components(separatedBy: ":")
                    product = product.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                    product = Array(product.dropFirst(4))
                    
                    if product.count % 3 == 0{
                        for index in stride(from: 0, to: product.count, by: 3) {
                            let name = product[index]
                            let quantityStr = product[index + 1]
                            let priceStr = product[index + 2]
                            
                            if let quantity = Int(quantityStr), let price = Double(priceStr) {
                                let productItem = ProductInfo(name: name, quantity: quantity, price: price)
                                productDetails.append(productItem)
                            }
                        }
                    }
                }
                
                
            }else if String(text.prefix(2)) == "**"{
                guard let range = text.range(of: "**") else { return }
                let details = String(text.suffix(from: range.upperBound))
                
                var product = details.components(separatedBy: ":")
                
                product = product.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                
                if product.count % 3 == 0{
                    for index in stride(from: 0, to: product.count, by: 3) {
                        let name = product[index]
                        let quantityStr = product[index + 1]
                        let priceStr = product[index + 2]
                        
                        if let quantity = Int(quantityStr), let price = Double(priceStr) {
                            let productItem = ProductInfo(name: name, quantity: quantity, price: price)
                            productDetails.append(productItem)
                        }
                    }
                }
                
            }else{
                let pattern = #"\b([A-Za-z]{2}\s\d{8})\b"#
                if let range = text.range(of: pattern, options: .regularExpression) {
                    if  range.lowerBound == text.startIndex && range.upperBound == text.endIndex{
                        if invoiceNumber == ""{
                            invoiceNumber = text
                        }
                    }
                }
                
            }
            print(invoiceNumber)
        }
        
        if invoiceNumber != ""{
            completion()
        }
    }
    
    func takePhotoAgain(view: AddNewItemViewController){
        let alertController = UIAlertController(title: "偵測發票失敗", message: "請重新載入發票照片", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { _ in
            view.showImagePicker(sourceType: .photoLibrary)
        })
        
        alertController.addAction(UIAlertAction(title: "拍照", style: .default) { _ in
            view.showImagePicker(sourceType: .camera)
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        view.present(alertController, animated: true)
    }
}

