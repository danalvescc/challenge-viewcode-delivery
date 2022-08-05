//
//  AddressSearchView.swift
//  DeliveryAppChallenge
//
//  Created by Rodrigo Borges on 04/02/22.
//

import UIKit

class AddressListView: UIView {
    private let addressCellIdentifier = "AddressCellIdentifier"
    
    private var addresses: [Address] = []
    private var filteredAddress: [Address] = []
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Rua, número, bairro"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.register(AddressCell.self, forCellReuseIdentifier: self.addressCellIdentifier)
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemFill
        return view
    }()
    
    init(){
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(with addresses: [Address]) {
        self.addresses = addresses
        self.filteredAddress = addresses
        self.tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String){
        if searchText == "" {
            filteredAddress = addresses
        } else {
            filteredAddress = addresses.filter({ (address: Address) -> Bool in
                return "\(address.street), \(address.number)".lowercased().contains(searchText.lowercased())
                    || address.neighborhood.lowercased().contains(searchText.lowercased())
            })
        }
        
        self.tableView.reloadData()
    }
}

extension AddressListView: ViewCode {
    func setupSubviews() {
        addSubview(searchBar)
        addSubview(divider)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        setupTableViewConstraints()
        setupSearchbarConstaints()
        setupDividerConstraints()
    }
    
    func setupSearchbarConstaints(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: divider.topAnchor)
        ])
    }
    
    func setupDividerConstraints(){
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setupTableViewConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}


extension AddressListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchText)
    }
}

extension AddressListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.addressCellIdentifier) as! AddressCell
        let data = self.filteredAddress[indexPath.row]
        cell.updateView(address: "\(data.street), \(data.number)", neighborhood: data.neighborhood)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredAddress.count
    }
}
