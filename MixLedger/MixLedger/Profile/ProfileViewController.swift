//
//  ProfileViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/4.
//

import SnapKit
import UIKit

class ProfileViewController: UIViewController {
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
    let singOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.g3(), for: .normal)
        button.backgroundColor = .g1()
        return button
    }()

    @objc func appleSingOutButtonTapped() {
        FirebaseAuthenticationManager.signOut()
    }

    func setupButton() {
        singOutButton.layer.cornerRadius = 10
        singOutButton.addTarget(self, action: #selector(appleSingOutButtonTapped), for: .touchUpInside)
    }

    func setupLayout() {
        view.addSubview(singOutButton)

        singOutButton.snp.makeConstraints { mark in
            mark.height.equalTo(50)
            mark.width.equalTo(view.bounds.size.width * 0.5)
            mark.centerX.equalTo(view.safeAreaLayoutGuide)
            mark.centerY.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
