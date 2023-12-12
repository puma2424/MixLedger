//
//  SearchAllUserViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/22.
//

import SnapKit
import UIKit
class SearchAllUserViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
        setupTable()
        setupSearch()
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

//    var searchResults: [UsersInfoResponse] = []

    var allUsers: [UsersInfoResponse] = []

//    let searchController = UISearchController(searchResultsController: nil)
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

    func setupLayout() {
        view.addSubview(tableView)
//        view.addSubview(searchBar)
//        
//        searchBar.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.leading.equalTo(view.safeAreaLayoutGuide)
//            make.trailing.equalTo(view.safeAreaLayoutGuide)
//            make.height.equalTo(50)
//        }
        
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
        //        // 將更新搜尋結果的對象設為 self
        //        searchController.searchResultsUpdater = self
        //        // 搜尋時是否隱藏 NavigationBar
        //        searchController.hidesNavigationBarDuringPresentation = true
        //        // 搜尋框的樣式
        //        searchController.searchBar.searchBarStyle = .default
        //        // 設置搜尋框的尺寸為自適應
        //        // 因為會擺在 tableView 的 header
        //        // 所以尺寸會與 tableView 的 header 一樣
        //        searchController.searchBar.sizeToFit()
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        // 設定搜尋框的樣式和大小
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "搜尋"
    }

//    func filterContent(for searchText: String) {
//        searchResults = allUsers.filter { userInfo -> Bool in
//            let isMatch = userInfo.name.localizedCaseInsensitiveContains(searchText)
//            print(isMatch)
//            print(userInfo.name)
//            return isMatch
//        }
//    }

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

extension SearchAllUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
//        searchResults.count
        filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let searchCell = cell as? SearchUserTableViewCell else { return cell }
        cell.selectionStyle = .none
        searchCell.nameLabel.text = filteredData[indexPath.row].name
        if searchCell.postShareInfo == nil {
            searchCell.postShareInfo = {
                print("post \(self.filteredData[indexPath.row].name)")
                self.postInviteMessage(inviteeID: self.filteredData[indexPath.row].userID)
            }
        }
        return searchCell
    }
}

extension SearchAllUserViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 使用filter方法來篩選data，並將結果更新到filteredData
        filteredData = searchText.isEmpty ? allUsers : allUsers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }

        // 重新載入tableView，顯示更新後的結果
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 用戶按下鍵盤上的“Search”按鈕時的處理，你可以選擇實現或不實現這個方法，視你的需求而定。
    }
}
//
//extension SearchAllUserViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
//            filterContent(for: searchText)
//            tableView.reloadData()
//        }
//    }
//}
