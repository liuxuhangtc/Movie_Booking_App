//
//  SearchViewController.swift
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit
import KMNavigationBarTransition

class SearchViewController: MTBaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.searchBar.becomeFirstResponder()
    }

    
    @IBOutlet weak var table: UITableView!
    
    var searchBar: UISearchBar!
    
    var datas: [TheMovie] = []
    
    func addSearchBar() {
        addNavigationBarLeftButton(self)
        
        //UIColor *color =  self.navigationController.navigationBar.tintColor;
        //[titleView setBackgroundColor:color];
        
        self.searchBar = UISearchBar(frame: CGRect(x: 30, y: 0, width: UIScreen.main.bounds.width * 180 / 375, height: 40))
        self.searchBar.placeholder = "Enter keywords"

        self.searchBar.backgroundImage = UIImage()
        //self.searchBar.backgroundImage = [UIImage imageNamed:@"sexBankgroundImage"];

        //self.searchBar.barTintColor = .red
        self.searchBar.backgroundColor = .clear
        // cancel
        self.searchBar.showsCancelButton = true
        
        self.searchBar.barStyle = .default
        //self.searchBar.searchBarStyle = UISearchBarStyleMinimal;//没有背影，透明样式
        self.searchBar.delegate = self
        // cancel
        //self.searchBar.showsSearchResultsButton = true
        //5. Icon
        ///[self.searchBar setImage:[UIImage imageNamed:@"Search_Icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        self.navigationItem.titleView = self.searchBar
        
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSearchBar()
    }
    
    
    @IBAction func goDetail(_ index: Int) {
        //let detail = datas[index]
        //let vc = WebViewController(URL(string:  detail.url)!)
        
        let vc  = self.storyboard?.instantiateVC(MovieDetailViewController.self)
        vc?.movie = datas[index]
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        

        UIView.animate(withDuration: 0.4) {
            searchBar.showsCancelButton = true
            for v in searchBar.subviews {
                for _v in v.subviews {
                    if let _cls = NSClassFromString("UINavigationButton") {
                        if _v.isKind(of: _cls) {
                            guard let btn = _v as? UIButton else { return }
                            
                            btn.setTitle("Cancel", for: .normal)
                            btn.setTitleColor(UIColor.white, for: .normal)
                            return
                        }
                    }
                }
            }
        }
        
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("=======================")
        guard let t = searchBar.text else {return }
        searchBar.resignFirstResponder()
        MTHUD.showLoading()
        DataBase.getSearchMovies(1, query: t) { (list, _) in
            MTHUD.hide()
            self.datas = list
            self.table.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.datas = []
        self.table.reloadData()
    }
}


extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        goDetail(indexPath.row)
    }
}


extension SearchViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell") as! MovieTableCell
        cell.info = datas[indexPath.row]
        
        return cell
        
    }
    
}


class MovieTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var info: TheMovie? {
        didSet {
            if let m = info {
                titleLabel.text = m.title
                voteLabel.text = "\(m.vote_average)"
                ratingView.rating = m.vote_average / 2
                
                if let p = m.poster_path, let url = URL(string: imgUrl + p) {
                    coverImageView.kf.setImage(with: url)
                }
            }
        }
    }
    
    
}
