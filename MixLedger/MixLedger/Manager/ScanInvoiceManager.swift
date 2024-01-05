//
//  ScanInvoiceManager.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/25.
//

import Foundation
import UIKit
import Vision
import AVFoundation

struct ProductInfo {
    var name: String
    var quantity: Int
    var price: Double
}

class ScanInvoiceManager {
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    let imagePicker = UIImagePickerController()
    
    weak var viewController: UIViewController?
    
    var invoiceString: [String] = []
    
    var invoiceNumber: String = ""
    
    var invoiceDateString: String = ""
    
    var invoiceDate: Date = Date()
    
    var invoiceRandomNumber: String = ""
    
    var invoiceTotalAmount: String = ""
    
    var productDetails: [ProductInfo] = []
    
    enum ResultForm {
        case formQRCode([String])
    }
    
    private func imageToText(_ imageParameter: UIImage, completion: @escaping (Result<ResultForm, Error>) -> Void) {
        let barcodeDetectionRequest = VNDetectBarcodesRequest()
        barcodeDetectionRequest.symbologies = [.qr, .ean13, .code39]
        
        if let image = imageParameter.cgImage {
            let handler = VNImageRequestHandler(cgImage: image)
            
            DispatchQueue.global().async {
                do {
                    try handler.perform([barcodeDetectionRequest])
                    
                    if let barcodeResults = barcodeDetectionRequest.results {
                        var results: [String] = []
                        for observation in barcodeResults {
                            print("--Barcode Detection Result--")
                            if let content = observation.payloadStringValue {
                                results.append(content)
                            }
                        }
                        completion(.success(.formQRCode(results)))
                    } else {
                        let error = NSError(domain: "barcodeResults not results", code: 0, userInfo: nil)
                        completion(.failure(error))
                    }
                    
                } catch {
                    print("Error during recognition: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func displayBarcodeResults(selectedImage: UIImage, completion: @escaping (Result<ResultForm, Error>) -> Void) {
        imageToText(selectedImage) { result in
            
            DispatchQueue.main.async {
                switch result {
                case let .success(from):
                    switch from {
                    case let .formQRCode(result):
                        self.processInvoiceInfo(invioiceText: result)
                        guard self.invoiceNumber != "" else {
                            let error = NSError(domain: "解碼錯誤", code: 0, userInfo: nil)
                            self.takePhotoAgain()
                            completion(.failure(error))
                            return
                        }
                        completion(.success(.formQRCode([])))
                    }
                    
                case let .failure(error):
                    print(error)
                    self.takePhotoAgain()
                }
            }
        }
    }
    
    private func processMainInfo(_ text: String) {
        if text.contains("==") {
            guard var range = text.range(of: "==") else { return }
            let mainInfo = String(text.prefix(upTo: range.lowerBound))
            invoiceNumber = String(mainInfo.prefix(10))
            
            var dateString = String(mainInfo.prefix(10 + 7).suffix(7))
            if var dateInt = Int(dateString) {
                dateInt += 19_110_000
                dateString = "\(dateInt)"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                let date = dateFormatter.date(from: dateString)
                invoiceDate = date ?? Date()
            }
            invoiceDateString = dateString
            
            invoiceRandomNumber = String(mainInfo.prefix(10 + 7 + 4).suffix(4))
            
            // 金額被以16進位記載
            let totalAmount = String(mainInfo.prefix(10 + 7 + 4 + 16).suffix(8))
            
            if let scannedValue = Scanner(string: totalAmount).scanInt32(representation: .hexadecimal) {
                invoiceTotalAmount = "\(scannedValue)"
            }
            
            if let productsRange = text.range(of: "==:") {
                let details = String(text.suffix(from: productsRange.upperBound))
                var product = details.components(separatedBy: ":")
                product = product.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                product = Array(product.dropFirst(4))
                
                if product.count % 3 == 0 {
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
        }
    }
    
    private func processProductDetails(_ text: String) {
        // ... 產品詳細信息處理 ...
        if String(text.prefix(2)) == "**" {
            guard let range = text.range(of: "**") else { return }
            let details = String(text.suffix(from: range.upperBound))
            
            var product = details.components(separatedBy: ":")
            
            product = product.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            
            if product.count % 3 == 0 {
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
    }
    
    private func resetInvoiceInfo() {
        productDetails = []
        invoiceNumber = ""
        invoiceDateString = ""
        invoiceRandomNumber = ""
        invoiceTotalAmount = ""
    }
    
    private func processInvoiceInfo(invioiceText: [String]) {
        resetInvoiceInfo()
        invioiceText.forEach { text in
            processMainInfo(text)
            processProductDetails(text)
            print(invoiceNumber)
        }
    }
    func checkCamera(canUseCamera: @escaping () -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                guard success == true else { return }
                canUseCamera()
            }
        case .denied, .restricted:
            let alertController = UIAlertController(title: "相機啟用失敗", message: "相機服務未啟用", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "設定", 
                                               style: .default) { (_) in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            self.viewController?.present(alertController, animated: true, completion: nil)
            return
        case .authorized:
            print("Authorized, proceed")
            canUseCamera()
        }
    }
    
    private func takePhotoAgain() {
        let alertController = UIAlertController(title: "偵測發票失敗", message: "請重新載入發票照片", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        })
        
        alertController.addAction(UIAlertAction(title: "拍照", style: .default) { _ in
            self.checkCamera {
                self.showImagePicker(sourceType: .camera)
            }
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        viewController?.present(alertController, animated: true)
    }
    
    func selectPhotoButtonTapped() {
        imagePicker.sourceType = .photoLibrary
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "從相簿中選擇", style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        })
        
        alertController.addAction(UIAlertAction(title: "拍照", style: .default) { _ in
            self.checkCamera {
                self.showImagePicker(sourceType: .camera)
            }
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        viewController?.present(alertController, animated: true)
    }
    
    private func showImagePicker( sourceType: UIImagePickerController.SourceType) {
        guard let viewController = viewController else { return }
        if sourceType == .photoLibrary {
            imagePicker.sourceType = sourceType
            viewController.present(imagePicker, animated: true, completion: nil)
        } else if sourceType == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = sourceType
                viewController.present(imagePicker, animated: true, completion: nil)
            } else {
                LKProgressHUD.showFailure(inView: viewController.view, text: "設備不支援相機")
                print("設備不支援相機")
            }
        } else {
            LKProgressHUD.showFailure(inView: viewController.view, text: "相機不可用或其他情况")
            print("相機不可用或其他情况")
        }
    }
}
