//
//  SingInViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/4.
//

import UIKit
import AuthenticationServices
import SnapKit

class SingInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupButton()
        setupLayout()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    let singButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    
    func setupButton(){
        
    }
    
    func setupLayout(){
        view.addSubview(singButton)
        
        singButton.snp.makeConstraints{(mark) in
            mark.height.equalTo(80)
            mark.width.equalTo(view.bounds.size.width * 0.5)
            mark.centerX.equalTo(view)
            mark.centerY.equalTo(view)
        }
    }
}
