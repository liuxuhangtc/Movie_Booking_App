//
//  CustomersViewController.swift
//  MovieBooking
//
//  Created by Xuhang Liu on 2019/2/26.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit


class CustomersViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var customers: [Customer] = [] 
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filterCus: [Customer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNavigationBarLeftButton(self)
        
        title = "Customers"
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Customer"
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            table.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customers = DBManager.default.getCustomers()
        table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        switch vc {
        case is SearchViewController:
            (vc as! SearchViewController).type = .customer
            break
        case is CustomerDetailViewController:
            if segue.identifier == "showDetail" {
                (vc as! CustomerDetailViewController).cus = sender as? Customer
            }
            break
        default:
            break
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

}


extension CustomersViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomerCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "showDetail", sender: customers[indexPath.row])
        
//        let data = customers[indexPath.row]
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerDetailViewController") as! CustomerDetailViewController
//        vc.cus = data
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {_,_  in
            let alertController = UIAlertController(title: "Tips", message: "Delete customer detail?", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Delete", style: .default) { _ in
                
                DBManager.default.deleteCustomer(self.customers[indexPath.row].name!)
                print("Delete Success")
                self.customers.remove(at: indexPath.row)
                self.table.reloadData()
            }
            
            let action2 = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            }
            alertController.addAction(action1)
            alertController.addAction(action2)
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }
        
        return [deleteAction]
    }
    
}


extension CustomersViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: CGFloat.leastNormalMagnitude))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filterCus.count
        }
        return customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell") as! CustomerCell
        
        let selectionColor = UIView()
        selectionColor.backgroundColor = .lightGray
        cell.selectedBackgroundView = selectionColor
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if customers.count > indexPath.row {
            let tcell = cell as! CustomerCell
            if isFiltering() {
                tcell.record = filterCus[indexPath.row]
            } else {
                tcell.record = customers[indexPath.row]
            }
            
        }
        
    }
    
}



extension CustomersViewController: UISearchBarDelegate {
    
    func search(_ text: String?) {
        guard let v = text, v.count > 0 else {
            customers = DBManager.default.getCustomers()
            table.reloadData()
            return
        }

        filterCus = DBManager.default.getCustomers(v, filter: true)
        table.reloadData()
    }
    
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        search(searchBar.text)
    }
}


extension CustomersViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        search(text)
    }
}


class CustomerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    static var height: CGFloat = 65
    
    var record: Customer? {
        didSet {
            if let info = record {
                nameLabel.text =  info.name
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
