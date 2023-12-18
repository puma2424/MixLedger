//
//  ShareWithQRcodeViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/14.
//

import UIKit
import CoreImage

class ShareWithQRcodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
        view.backgroundColor = .g3()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupQRCode(text: urlString)
    }
    
    var urlString: String = ""

    
    let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    func setupQRCode(text: String) {
        guard let qrcodeImage = CreateQRCodeManager.createQRCodeForString(text, size: view.bounds.size) else { return }

        qrCodeImageView.image = UIImage(ciImage: qrcodeImage)
        
    }
    
    func setupLayout(){
        view.addSubview(qrCodeImageView)
        
        qrCodeImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view).offset(24)
            make.height.width.equalTo(view.bounds.size.width * 0.8)
        }
    }
}
