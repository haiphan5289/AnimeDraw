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
