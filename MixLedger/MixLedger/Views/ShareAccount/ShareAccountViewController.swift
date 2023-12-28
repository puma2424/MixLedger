//
//  ShareAccountViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/22.
//

import SnapKit
import UIKit
class ShareAccountViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
        setupTable()
        setupSearch()
        addRightBarButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllUser()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    let firebaseManager = FirebaseManager.shared

    let saveData = SaveData.shared

    var accountIDWithShare: String = ""

    var allUsers: [UsersInfoResponse] = []

    var searchBar = UISearchBar()
    var filteredData = [UsersInfoResponse]()

    let tableView = UITableView()

    func getAllUser() {
        allUsers = []
        firebaseManager.getAllUser { result in
            switch result {
            case let .success(data):
                self.allUsers = data
                return
            case let .failure(error):
                print(error)
            }
        }
    }

    func addRightBarButton() {
        navigationController?.navigationBar.tintColor = .brightGreen3()

        let shareUrlImare = UIImage(systemName: "square.and.arrow.up")?.withTintColor(.brightGreen3(), renderingMode: .alwaysOriginal)
        let qrCodeImare = UIImage(systemName: "qrcode")?.withTintColor(.brightGreen3(), renderingMode: .alwaysOriginal)
        // 導覽列右邊按鈕
        let shareButton = UIBarButtonItem(
            //          title:"設定",
            image: shareUrlImare,
            style: .plain,
            target: self,
            action: #selector(shareAccountBookWithUrl)
        )

        let qrCodeButton = UIBarButtonItem(
            //          title:"設定",
            image: qrCodeImare,
            style: .plain,
            target: self,
            action: #selector(shareAccountBookWithQrCode)
        )
        // 調整兩個按鈕之間的距離
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 0 // 調整距離
        // 加到導覽列中
        navigationItem.rightBarButtonItems = [shareButton, fixedSpace, qrCodeButton]
    }

    func creatUrlString() -> String {
        guard let accountID = saveData.accountData?.accountID else { return "" }
        let endPoint = UrlRouteManager.EndPoint.account
        return UrlRouteManager.createUrlString(for: endPoint, components: [accountID])
    }

    @objc func shareAccountBookWithUrl() {
        guard let accountName = saveData.accountData?.accountName else {
            LKProgressHUD.showFailure()
            return
        }
        var text = ""
        text += "您被邀請進入共享帳簿：\(accountName)"
        text += "\n"
        text += "\n點擊以下連結加入帳簿"
        text += "\n\(creatUrlString())"

//        ShowShareViewManager.showShare(content: [text], viewController: self)
        showShare(content: [text])
    }

    @objc func shareAccountBookWithQrCode() {
        guard let accountName = saveData.accountData?.accountName else {
            LKProgressHUD.showFailure()
            return
        }

        let qrCodeView = ShareWithQRcodeViewController()
//        qrCodeView.setupQRCode(text: creatUrlString())
        qrCodeView.urlString = creatUrlString()
        qrCodeView.modalPresentationStyle = .automatic
        qrCodeView.modalTransitionStyle = .coverVertical
        qrCodeView.sheetPresentationController?.detents = [.custom(resolver: { context in
            context.maximumDetentValue * 0.45
        }
        )]
        present(qrCodeView, animated: true)
    }

    func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setupTable() {
//        tableView.tableHeaderView = searchController.searchBar
        tableView.tableHeaderView = searchBar

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupSearch() {
        searchBar.sizeToFit()
        searchBar.delegate = self

        // 設定搜尋框的樣式和大小
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "搜尋"
    }

    func postInviteMessage(inviteeID: String) {
        LKProgressHUD.show()
        if let accountName = saveData.accountData?.accountName, let myName = saveData.myInfo?.name {
            firebaseManager.postShareAccountInivite(inviteeID: inviteeID, shareAccountID: accountIDWithShare, shareAccountName: accountName, inviterName: myName) { result in
                switch result {
                case .success:
                    LKProgressHUD.showSuccess()
                case let .failure(error):
                    LKProgressHUD.showFailure()
                }
            }
        }
    }
}

extension ShareAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let searchCell = cell as? SearchUserTableViewCell else { return cell }
        cell.selectionStyle = .none
        searchCell.nameLabel.text = filteredData[indexPath.row].name
        searchCell.postShareInfo = nil
        if searchCell.postShareInfo == nil {
            searchCell.postShareInfo = {
                print("post \(self.filteredData[indexPath.row].name)")
                self.postInviteMessage(inviteeID: self.filteredData[indexPath.row].userID)
            }
        }
        return searchCell
    }
}

extension ShareAccountViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        // 使用filter方法來篩選data，並將結果更新到filteredData
        filteredData = searchText.isEmpty ? allUsers : allUsers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        filteredData.removeAll {
//            let usreID = $0.userID
//            let user = saveData.userInfoData.filter { $0.userID == usreID }
//            if user.count > 0 || $0.userID == saveData.myID {
//                return true
//            }
//            return false
            $0.userID == saveData.myID
        }
        // 重新載入tableView，顯示更新後的結果
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        // 用戶按下鍵盤上的“Search”按鈕時的處理，你可以選擇實現或不實現這個方法，視你的需求而定。
    }
}

//
// extension ShareAccountViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
//            filterContent(for: searchText)
//            tableView.reloadData()
//        }
//    }
// }
