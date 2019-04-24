//
//  ReviewsViewController.swift
//  MovelRater
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

class ReviewsViewController: MTBaseViewController {


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var table: UITableView!
    
    
    var datas: [JSONMap] = []
    
    var id: Int?
    var cover: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationBarLeftButton(self)
        
        table.estimatedRowHeight =  44.0
        table.rowHeight = UITableView.automaticDimension
        table.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: table.width, height: table.width * 2 / 3)
        
        if let c = cover , let url = URL(string: imgUrl + c) {
            coverImageView.kf.setImage(with: url)
        }
        
        if let id = self.id {
            MTHUD.showLoading()
            DataBase.getMovieReviews(id, completionHandle: { (res) in
                MTHUD.hide()
                self.datas = res
                self.table.reloadData()
            }, failedHandle: {
                MTHUD.hide()
                showMessage("")
            })
        }
        
    }
    
    

    
}

extension ReviewsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsCell") as! ReviewsCell
        cell.info = datas[indexPath.row]
        
        return cell
        
    }
    
}


class ReviewsCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var info: JSONMap? {
        didSet {
            contentLabel.text = info?["content"] as? String
            if let au =  info?["author"] as? String {
                authorLabel.text = "—— " + au
            }
            
            
        }
    }
    
    
}
