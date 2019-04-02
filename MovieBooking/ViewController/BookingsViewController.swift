//
//  BookingsViewController.swift
//  MovieBooking
//
//  Created by Xuhang Liu on 2019/2/26.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

class BookingsViewController: UIViewController {


    @IBOutlet weak var table: UITableView!
    
    var bookings: [Booking] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
     var filterBookings: [Booking] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarLeftButton(self)
        
        title = "Bookings"
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Booking"
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
        
        bookings = DBManager.default.getBooking()
        table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        switch vc {
        case is SearchViewController:
            (vc as! SearchViewController).type = .booking
            break;
        case is BookingDetailViewController:
            if segue.identifier == "showDetail" {
                (vc as! BookingDetailViewController).booking = sender as? Booking
            }
            break
        default:
            break;
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

extension BookingsViewController: UISearchBarDelegate {
    
    func search(_ text: String?) {
        guard let v = text, v.count > 0 else {
            bookings = DBManager.default.getBooking()
            table.reloadData()
            return
        }

        filterBookings = DBManager.default.getBooking(v, filter: true)
        table.reloadData()
    }
    
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        search(searchBar.text)
    }
}

extension BookingsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        search(text)
    }
}


extension BookingsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookingCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "showDetail", sender: bookings[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {_,_  in
            let alertController = UIAlertController(title: "Tips", message: "Delete booking detail?", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Delete", style: .default) { _ in
                
                DBManager.default.deleteBooking(self.bookings[indexPath.row])
                print("Delete Success")
                self.bookings.remove(at: indexPath.row)
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


extension BookingsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: CGFloat.leastNormalMagnitude))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filterBookings.count
        }
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell") as! BookingCell
        
        let selectionColor = UIView()
        selectionColor.backgroundColor = .lightGray
        cell.selectedBackgroundView = selectionColor
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if bookings.count > indexPath.row {
            let tcell = cell as! BookingCell
            
            if isFiltering() {
                tcell.record = filterBookings[indexPath.row]
            } else {
                tcell.record = bookings[indexPath.row]
            }
        }
        
    }
    
}

class BookingCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    static var height: CGFloat = 65
    
    var record: Booking? {
        didSet {
            if let info = record {
                nameLabel.text =  info.movie!.title! + "  --  " + info.customer!.name!
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
