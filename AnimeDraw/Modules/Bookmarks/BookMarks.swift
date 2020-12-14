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
                                                                    navigationOrientation: .horizontal, options: [:])
    @VariableReplay private var listStep: [StepModel] = []
    private var controllers: [UIViewController] = []
    private(set) lazy var step: UIViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"BookMarks") as! BookMarks
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
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.addChild(pageVC)
        pageVC.didMove(toParent: self)
        
        self.listStep = RealmManage.share.getStepByStep()
        tableView.delegate = self
        tableView.register(BMStepCell.nib, forCellReuseIdentifier: BMStepCell.identifier)
    }
    private func setupRX() {
        segmentControl.rx
            .selectedSegmentIndex
            .skip(1)
            .bind (onNext: { index in
                self.pageVC.setViewControllers( (index == 0) ? [self.step] : [self.tutorial] ,
                                            direction: .forward,
                                            animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        self.$listStep.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: BMStepCell.identifier, cellType: BMStepCell.self)) {(row, element, cell) in
                cell.lbTitle.text = element.text
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { [weak self] (idx) in
            guard let wSelf = self else {
                return 
            }
            let vc = StepDetail(nibName: "StepDetail", bundle: nil)
            let item = wSelf.listStep[idx.row]
            vc.anime = item
            vc.hidesBottomBarWhenPushed = true
            wSelf.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
}
extension BookMarks: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
