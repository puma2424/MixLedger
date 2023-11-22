//
//  SearchAllUserViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/22.
//

import UIKit
import SnapKit
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
    
    var accountIDWithShare: String = ""
    
    var searchResults: [UsersInfoResponse] = []
    
    var allUsers: [UsersInfoResponse] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let tableView = UITableView()
    
    func getAllUser(){
        allUsers = []
        firebaseManager.getAllUser{result in
            switch result{
            case .success(let data):
                self.allUsers = data
                return
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func setupLayout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{(mark) in
            mark.top.equalTo(view.safeAreaLayoutGuide)
            mark.leading.equalTo(view.safeAreaLayoutGuide)
            mark.trailing.equalTo(view.safeAreaLayoutGuide)
            mark.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupTable(){
        tableView.tableHeaderView = searchController.searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupSearch(){
        // 將更新搜尋結果的對象設為 self
        searchController.searchResultsUpdater = self
        // 搜尋時是否隱藏 NavigationBar
        searchController.hidesNavigationBarDuringPresentation = true
        // 搜尋框的樣式
        searchController.searchBar.searchBarStyle = .default
        // 設置搜尋框的尺寸為自適應
        // 因為會擺在 tableView 的 header
        // 所以尺寸會與 tableView 的 header 一樣
        self.searchController.searchBar.sizeToFit()
    }
    
    func filterContent(for searchText: String) {
        searchResults = allUsers.filter({ (userInfo) -> Bool in
            let isMatch = userInfo.name.localizedCaseInsensitiveContains(searchText)
            print(isMatch)
            print(userInfo.name)
            return isMatch
        })
    }
}

extension SearchAllUserViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let searchCell = cell as? SearchUserTableViewCell else { return cell }
        
        searchCell.nameLabel.text = searchResults[indexPath.row].name
        if searchCell.postShareInfo == nil {
            searchCell.postShareInfo = {
                print("post \(self.searchResults[indexPath.row].name)")
            }
        }
        return searchCell
    }
    
    
}

extension SearchAllUserViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filterContent(for: searchText)
            tableView.reloadData()
        }
        
    }
    
    
}
