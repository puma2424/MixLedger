//
//  SelectIconViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/17.
//

import UIKit

protocol SelectIconViewControllerDelegate {
    func setupIconGroup(selectionIconView: SelectIconViewController, selectIconManager: SelectIconManager)
}

class SelectIconViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
        setCollectionView()
        delegate?.setupIconGroup(selectionIconView: self, selectIconManager: SelectIconManager())
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    var delegate: SelectIconViewControllerDelegate?

    var selectedSubType: ((String, String) -> Void)?

    var selectedIndex: IndexPath?

    var iconGroup: IconGroup?

    let iconCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        // 設置其他 collectionView 屬性，例如 delegate 和 dataSource
        return collectionView
    }()

    func setCollectionView() {
        iconCollectionView.dataSource = self
        iconCollectionView.delegate = self
        iconCollectionView.register(SubTypeIconCollectionViewCell.self, forCellWithReuseIdentifier: "subTypeIconCell")
    }

    func setupLayout() {
        view.addSubview(iconCollectionView)

        iconCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SelectIconViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let iconGroup = iconGroup else { return 0 }
        return iconGroup.items.count
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = iconCollectionView.dequeueReusableCell(withReuseIdentifier: "subTypeIconCell", for: indexPath)
        guard let subTypeCell = cell as? SubTypeIconCollectionViewCell else { return cell }
        guard let iconItem = iconGroup?.items[indexPath.row] else { return cell }
        subTypeCell.didSeiected(selected: false)
        subTypeCell.layoutCell(image: iconItem.image, text: iconItem.title)
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selected = selectedIndex {
            if let selectedCell = iconCollectionView.cellForItem(at: selected) as? SubTypeIconCollectionViewCell {
                selectedCell.didSeiected(selected: false)
            }
        }

        selectedIndex = indexPath

        guard let selectedCell = iconCollectionView.cellForItem(at: indexPath) as? SubTypeIconCollectionViewCell else { return }
        guard let iconItem = iconGroup?.items[indexPath.row] else { return }

        selectedCell.didSeiected(selected: true)
        selectedSubType?(iconItem.name, iconItem.title)

        print(iconItem.name)
    }
}

extension SelectIconViewController: UICollectionViewDelegateFlowLayout {
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
