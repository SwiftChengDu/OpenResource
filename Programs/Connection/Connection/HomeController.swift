//
//  HomeController.swift
//  Connection
//
//  Created by 杨涵 on 16/4/8.
//  Copyright © 2016年 yanghan. All rights reserved.
//

import UIKit

private let kCellReuseIdentifier = "homecell"
private let kCellInsets          = UIEdgeInsetsMake(15,15,15,15)
private let kToTopicDetailSegue  = "home2TopicDetail"

class HomeController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var layout: UICollectionViewFlowLayout!
    
    private var queryFollowData: Bool = false
    private var baseSortValue: String = "0"
    
    private lazy var topMenu: TopMenu = {
        let t = TopMenu.loadFromNib()
        t.showText = ("精选","关注")
        t.delegate = self
        return t
    }()
    
    private lazy var leftRefreshView: LeftRefreshView = {
        let v = LeftRefreshView()
        v.addTarget(self, action: #selector(HomeController.loadData as (HomeController) -> () -> ()), forControlEvents: .ValueChanged)
        return v
    }()
    
    private lazy var dataList: [TopicInfo] = {
        return [TopicInfo]()
    }()
    
    /// “精选”数据
    private lazy var topDataList: [TopicInfo] = {
        return [TopicInfo]()
    }()
    
    /// "关注"数据
    private lazy var followDataList: [TopicInfo] = {
        return [TopicInfo]()
    }()
    
    func loadData() {
        loadData(.New)
    }
    
    private func loadData(query: QueryMethod) {
        var sortValue: String = ""
        if query == .New {
            sortValue = "0"
        }else {
            sortValue = baseSortValue
        }
        
        TopicInfo.fetchTopicInfoList(isFollow: queryFollowData, order: 1, sortValue: sortValue) { [weak self] (isEnd, sortValue, topicInfoList) in
            if let strongSelf = self {
                if topicInfoList?.count > 0 {
                    strongSelf.baseSortValue = sortValue
                    if query == .New {
                        strongSelf.dataList = topicInfoList!
                    }else {
                        strongSelf.dataList.appendContentsOf(topicInfoList!)
                    }
                    if strongSelf.queryFollowData {
                        strongSelf.followDataList = strongSelf.dataList
                    }else {
                        strongSelf.topDataList = strongSelf.dataList
                    }
                }
                strongSelf.leftRefreshView.endRefresh()
                strongSelf.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.titleView = topMenu
        collectionView?.addSubview(leftRefreshView)
        loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let width = CGRectGetWidth(view.bounds) - kCellInsets.left - kCellInsets.right
        let height = CGRectGetHeight(view.bounds) - kCellInsets.top - kCellInsets.bottom
        layout.itemSize = CGSizeMake(width, height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HomeController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellReuseIdentifier, forIndexPath: indexPath) as! HomeCollectionViewCell
        cell.delegate = self
        cell.topiInfo = dataList[indexPath.row]
        return cell
    }
}

extension HomeController: TopMenuDelegate {
    func topMenu(topMenu: TopMenu, didClickButton index: Int) {
        queryFollowData = (index == 1)
        
        //因为topdatalist开始就有数据，所以这里对followdatalist作判断，切换控制栏不进行数据请求，因为本地都有数据
        if followDataList.count > 0 {
            self.dataList = (index == 0) ? self.topDataList : self.followDataList
            self.collectionView.reloadData()
            return
        }
        loadData()
    }
}

extension HomeController: HomeCollectionViewCellDelegate {
    func homeCollectionViewCell(cell: HomeCollectionViewCell, didClickButton button: UIButton, withButtonType btnType: HomeCollectionViewCellButtonType, withTopiInfo topiInfo: TopicInfo) {
        switch btnType {
        case .Tag:
            cellDidClickTagButton(topiInfo)
        case .Chat:
            cellDidClickChatButton(topiInfo)
        case .Comment:
            cellDidClickCommentButton(topiInfo)
        case .Star:
            cellDidClickStarButton(topiInfo)
        }
    }
    
    private func cellDidClickTagButton(topiInfo: TopicInfo) {
        
    }
    
    private func cellDidClickChatButton(topiInfo: TopicInfo) {
        
    }
    
    private func cellDidClickCommentButton(topiInfo: TopicInfo) {
        
    }
    
    private func cellDidClickStarButton(topiInfo: TopicInfo) {
        
    }
}

extension HomeController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}