//
//  CollectionViewController.swift
//  MovelRater
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

class CollectionViewController: MTBaseViewController {


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        datas = DBManager.default.getMovies()
        table.reloadData()
    }
    
    
    @IBOutlet weak var table: UITableView!
    
    
    var datas: [Movie] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection"
        
    }
    
    
    @IBAction func goDetail(_ index: Int) {
        let detail = datas[index]
        MTHUD.showLoading()
        DataBase.getMovieDetail(Int(detail.id), completionHandle: { (m) in
            MTHUD.hide()
            let vc  = self.storyboard?.instantiateVC(MovieDetailViewController.self)
            vc?.movie = m
            self.navigationController?.pushViewController(vc!, animated: true)
        }) {
            MTHUD.hide()
        }
        
    }
    
}

extension CollectionViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        goDetail(indexPath.row)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let d = datas[indexPath.row]
            DBManager.default.deleteMovie(Int(d.id))
            datas.remove(at: indexPath.row)
            table.reloadData()
        }
    }



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollCell") as! CollCell
        cell.info = datas[indexPath.row]
        
        return cell
        
    }
    
}


class CollCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var info: Movie? {
        didSet {
            if let m = info {
                titleLabel.text = m.title
                voteLabel.text = "\(m.vote_average)"
                ratingView.rating = m.vote_average / 2
                
                if let p = m.cover, let url = URL(string: imgUrl + p) {
                    coverImageView.kf.setImage(with: url)
                }
            }
        }
    }
    
    
}
