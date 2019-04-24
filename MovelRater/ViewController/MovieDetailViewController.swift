//
//  MovieDetailViewController.swift
//  MovelRater
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit
import KMNavigationBarTransition

class MovieDetailViewController: MTBaseViewController {

    @IBOutlet weak var coverImgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descLabel: UITextView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var likeBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    var movie: TheMovie?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        backBtn.setImage(AppConfig.backImage, for: .normal)
        backBtn.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        
        if let m = movie {
            titleLabel.text = m.title
            ratingLabel.text = "\(m.vote_average)"
            dateLabel.text = m.release_date
            if let p = m.poster_path, let url = URL(string: imgUrl + p) {
                coverImgView.kf.setImage(with: url)
            }
            descLabel.text = m.overview
            
            if DBManager.default.getMovieBy(m.id).count > 0 {
                self.likeBtn.isSelected = true
            }
        }
        
        
    }
    
    @IBAction func like(_ sender: UIButton) {
        if !User.isLogined {
            AppDelegate.toLogin()
            return 
        }
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            DBManager.default.addMovie(movie!)
        } else {
            DBManager.default.deleteMovie(movie!.id)
        }
        
    }
    
    @IBAction func toReviews() {
        let vc = self.storyboard?.instantiateVC(ReviewsViewController.self)
        vc?.cover = movie?.poster_path
        vc?.id = movie?.id
        vc?.title = movie?.title
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
