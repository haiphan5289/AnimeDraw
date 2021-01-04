//
//  BookMarks.swift
//  AnimeDraw
//
//  Created by haiphan on 12/5/20.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import ViewAnimator
import SnapKit
import GoogleMobileAds

class BookMarks: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private var pageVC: UIPageViewController = UIPageViewController(transitionStyle: .pageCurl,
                                                                    navigationOrientation: .horizontal,
                                                                    options: [:])
    
    private var controllers: [UIViewController] = []
    private(set) lazy var step: UIViewController = {
        let vc = BMStepByStep(nibName: "BMStepByStep", bundle: nil)
        return vc
    }()
    private(set) lazy var tutorial: UIViewController = {
        let vc = BookMarksTutorial(nibName: "BookMarksTutorial", bundle: nil)
        return vc
    }()
    private let banner: GADBannerView = {
       let b = GADBannerView()
        //source
//        ca-app-pub-3940256099942544/2934735716
        //drawanime
        //ca-app-pub-1498500288840011/7599119385
        //ca-app-pub-1498500288840011/7599119385
        b.adUnitID = "ca-app-pub-1498500288840011/7599119385"
        b.load(GADRequest())
        b.adSize = kGADAdSizeSmartBannerPortrait
        b.backgroundColor = .secondarySystemBackground
        return b
    }()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.visualize()
        self.setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.hidesBottomBarWhenPushed = false
        guard let navigationController = navigationController else { return }
            navigationController.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .automatic
            navigationController.navigationBar.sizeToFit()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
extension BookMarks {
    private func visualize() {
        self.view.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.addChild(pageVC)
        pageVC.didMove(toParent: self)
        
        
        pageVC.setViewControllers([self.step], direction: .forward, animated: true, completion: nil)
        
//        banner.rootViewController = self
//        self.view.addSubview(banner)
//        banner.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.height.equalTo(50)
//            make.width.equalToSuperview()
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
//        }
    }
    private func setupRX() {
        segmentControl.rx
            .selectedSegmentIndex
            .skip(1)
            .bind (onNext: { index in
                self.pageVC.setViewControllers( (index == 0) ? [self.step] : [self.tutorial] ,
                                                direction: (index == 0) ? .reverse : .forward,
                                            animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}
