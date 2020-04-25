//
//  ShowViewController.swift
//  LCBanner_Example
//
//  Created by 卢荫豪 on 2020/4/25.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import LCBanner
let cellReuseId = "cellReuseId"
class ShowViewController: UIViewController {
    //MARK: - INITILAL
    init(style: LCBannerStyle) {
        self.bannerStyle = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.bannerStyle = .unknown
        super.init(coder: aDecoder)
    }
    
    deinit {
        NSLog("[%@ -- %@]", NSStringFromClass(self.classForCoder), #function)
    }
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bannerView.bannerWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.bannerView.bannerWillDisAppear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - PROPERTY
    let bannerStyle: LCBannerStyle
    
    let imgNames = ["1.jpg",
                    "2.jpg",
                    "3.jpg",
                    "4.jpg",
                    "5.jpg"]
    
    public lazy var bannerView: LCBanner = {
        let layout = LCSwiftFlowLayout.init(style: self.bannerStyle)
        let banner = LCBanner.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 240), flowLayout: layout, delegate: self)
        self.view.addSubview(banner)
        
        banner.backgroundColor = self.view.backgroundColor
        banner.banner.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseId)
        
        banner.autoPlay = true
        banner.endless = true
        banner.timeInterval = 2
        
        return banner
    }()
}

//MARK: - LCBannerDelegate
extension ShowViewController: LCBannerDelegate {
  public  func bannerNumbers() -> Int {
        return self.imgNames.count
    }
    
   public func bannerView(banner: LCBanner, index: Int, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = banner.banner.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath)
        var imgView = cell.contentView.viewWithTag(999)
        var label = cell.contentView.viewWithTag(888)
        if imgView == nil {
            imgView = UIImageView.init(frame: cell.contentView.bounds)
            imgView?.tag = 999
            cell.contentView.addSubview(imgView!)
            imgView?.layer.cornerRadius = 4.0
            imgView?.layer.masksToBounds = true
            
            label = UILabel.init(frame: CGRect.init(x: 30, y: 0, width: 60, height: 30))
            (label as! UILabel).textColor = UIColor.white
            (label as! UILabel).font = UIFont.systemFont(ofSize: 21)
            label?.tag = 888
            cell.contentView.addSubview(label!)
        }
        (imgView as! UIImageView).image = UIImage.init(named: self.imgNames[index])
        (label as! UILabel).text = "\(index)"
        return cell
    }
    
   public func didSelected(banner: LCBanner, index: Int, indexPath: IndexPath) {
        print("点击 \(index) click...")
    }
    
   public func didStartScroll(banner: LCBanner, index: Int, indexPath: IndexPath) {
        print("开始滑动: \(index) ...")
    }
    
   public func didEndScroll(banner: LCBanner, index: Int, indexPath: IndexPath) {
        print("结束滑动: \(index) ...")
    }
}

// MARK: - CONFIGURE UI
extension ShowViewController {
    fileprivate func configureUI() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "show"
        self.bannerView.freshBanner()
        self.automaticallyAdjustsScrollViewInsets = false
    }
}