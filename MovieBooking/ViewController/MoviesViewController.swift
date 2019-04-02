//
//  MoviesViewController.swift
//  MovieBooking
//
//  Created by Xuhang Liu on 2019/2/26.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var movies: [Movie] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filterMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarLeftButton(self)
        
        title = "Movies"
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movie"
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
        
        movies = DBManager.default.getMovies()
        table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        switch vc {
        case is SearchViewController:
            (vc as! SearchViewController).type = .movie
            break;
        case is MovieDetailViewController:
            if segue.identifier == "showDetail" {
                (vc as! MovieDetailViewController).mov = sender as? Movie
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

extension MoviesViewController: UISearchBarDelegate {
    
    func search(_ text: String?) {
        guard let v = text, v.count > 0 else {
            movies = DBManager.default.getMovies()
            table.reloadData()
            return
        }

        filterMovies = DBManager.default.getMovies(v, filter: true)
        table.reloadData()
    }
    
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        search(searchBar.text)
    }
}


extension MoviesViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        search(text)
    }
}

extension MoviesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "showDetail", sender: movies[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {_,_  in
            let alertController = UIAlertController(title: "Tips", message: "Delete movie detail?", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Delete", style: .default) { _ in
                DBManager.default.deleteMovie(self.movies[indexPath.row].title!)
                
                print("Delete Success")
                self.movies.remove(at: indexPath.row)
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


extension MoviesViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: CGFloat.leastNormalMagnitude))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filterMovies.count
        }
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let selectionColor = UIView()
        selectionColor.backgroundColor = .lightGray
        cell.selectedBackgroundView = selectionColor
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if movies.count > indexPath.row {
            let tcell = cell as! MovieCell
            
            if isFiltering() {
                tcell.record = filterMovies[indexPath.row]
            } else {
                tcell.record = movies[indexPath.row]
            }
        }
        
    }
    
}

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static var height: CGFloat = 72
    
    var record: Movie? {
        didSet {
            if let info = record {
                nameLabel.text =  info.title
                coverImageView.image  = UIImage(contentsOfFile: info.cover!)
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
