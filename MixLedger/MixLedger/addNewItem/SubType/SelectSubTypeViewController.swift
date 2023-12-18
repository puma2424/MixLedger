//
//  SelectSubTypeViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/8.
//

import SnapKit
import UIKit

class SelectSubTypeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
        setCollectionView()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    var selectedSubType: ((String, String) -> Void)?

    var selectedIndex: IndexPath?

    let iconArray: [SubTypeItem] = SubTypeItem.allCases

    let subTypeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        // 設置其他 collectionView 屬性，例如 delegate 和 dataSource
        return collectionView
    }()

    func setCollectionView() {
        subTypeCollectionView.dataSource = self
        subTypeCollectionView.delegate = self
        subTypeCollectionView.register(SubTypeIconCollectionViewCell.self, forCellWithReuseIdentifier: "subTypeIconCell")
    }

    func setupLayout() {
        view.addSubview(subTypeCollectionView)

        subTypeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SelectSubTypeViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        iconArray.count
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = subTypeCollectionView.dequeueReusableCell(withReuseIdentifier: "subTypeIconCell", for: indexPath)
        guard let subTypeCell = cell as? SubTypeIconCollectionViewCell else { return cell }
        subTypeCell.layoutCell(image: iconArray[indexPath.row].image, text: iconArray[indexPath.row].title)
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selected = selectedIndex {
            guard let selectedCell = subTypeCollectionView.cellForItem(at: selected) as? SubTypeIconCollectionViewCell else { return }
            selectedCell.didSeiected(selected: false)
        }

        selectedIndex = indexPath

        guard let selectedCell = subTypeCollectionView.cellForItem(at: indexPath) as? SubTypeIconCollectionViewCell else { return }
        selectedCell.didSeiected(selected: true)

        selectedSubType?(iconArray[indexPath.row].name, iconArray[indexPath.row].title)

        print(iconArray[selectedIndex!.row].name)
    }
}

extension SelectSubTypeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        // 返回每個 cell 的大小
        return CGSize(width: UIScreen.main.bounds.width / 4.0, height: 90)
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        minimumLineSpacingForSectionAt _: Int
    ) -> CGFloat {
        return 10
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt _: Int
    ) -> CGFloat {
        return 0
    }
}
