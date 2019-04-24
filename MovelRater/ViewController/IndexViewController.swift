//
//  ViewController.swift
//  MovelRater
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit
fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 0.0, right: 10)
fileprivate let itemsPerRow: CGFloat = 2


fileprivate let reuseIdentifier = "IndexCell"

class HomeViewController: MTBaseViewController {
    private let viewPagerNavigationBar: BmoViewPagerNavigationBar = BmoViewPagerNavigationBar()
    
    @IBOutlet weak var viewPager: BmoViewPager!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //viewPagerNavigationBar.frame = CGRect(x: 0, y: 0, width: 150, height: 44)
        //viewPagerNavigationBar.center = navigationItem.titleView!.center
        print(navigationItem.titleView!.frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationBarRightButton(self, action: #selector(toSearch), image: UIImage(named: "search")!)
        
        viewPager.dataSource = self
        viewPagerNavigationBar.autoFocus = false
        viewPagerNavigationBar.viewPager = viewPager
        
        viewPagerNavigationBar.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 135, y: 0, width: 270, height: 42)
        navigationItem.titleView = viewPagerNavigationBar
    }
    @objc func toSearch() {
        let vc = self.storyboard?.instantiateVC(SearchViewController.self)
        vc!.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}

extension HomeViewController: BmoViewPagerDataSource {
    // Optional
    @objc func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0),
            NSAttributedString.Key.foregroundColor : MTColor.des999
            //NSForegroundColorAttributeName : UIColor.groupTableViewBackground
        ]
    }
    @objc func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16.0),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
    }
    
    
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let view = UnderLineView()
        view.marginX = 15.0
        view.lineWidth = 3.0
        view.strokeColor = .white
        return view
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        return CGSize(width: 90 , height: navigationBar.height)
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        return ["Top rate", "Upcoming", "Playing"][page]
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 3
    }
    
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        let vc = UIStoryboard.Scene.index
        vc.index = page
        return vc
    }
}


class IndexViewController: MTBaseViewController {
    var index = 0
    var movies: [TheMovie] = []
    
    fileprivate var start = 1 {
        didSet {
            self.getDatas()
        }
    }
    fileprivate var totalPages = 0
    
    @IBOutlet weak var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addNavigationBarRightButton(self, action: #selector(toSearch), image: UIImage(named: "search")!)
        
        collection.addRefresh(String.init(describing: self), autoRefresh: false, headerRefresh: { [weak self] in
            self?.refresh()
        }) { [weak self] in
            self?.loadMore()
        }
        
        refresh()
    }
    
    /// 刷新数据
    private func refresh() {
        start = 1
    }
    
    private func loadMore() {
        if start < totalPages {
            start += 1
            collection.es.resetNoMoreData()
        } else {
            collection.es.noticeNoMoreData()
        }
    }
    
    func getDatas() {
        MTHUD.showLoading()
        DataBase.getMovies(start, type: index) { (list, pages) in
            MTHUD.hide()
            self.totalPages = pages
            if self.start == pages {
                self.collection.es.noticeNoMoreData()
            }
            self.movies.append(contentsOf: list)
            self.collection.reloadData()
            
            self.collection.es.stopPullToRefresh()
            self.collection.es.stopLoadingMore()
        }
    }
    


}



extension IndexViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int {
  
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IndexCell
        
        cell.bind(movies[indexPath.row])
        return cell
    }
    

    
}

extension IndexViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace - 5
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * (230.0 / 180.0)  //(180.0 / 166.0)
        print(paddingSpace)
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.width, height:44)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return sectionInsets.left
    }
}

extension IndexViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc  = self.storyboard?.instantiateVC(MovieDetailViewController.self)
        vc?.movie = movies[indexPath.row]
        vc?.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
