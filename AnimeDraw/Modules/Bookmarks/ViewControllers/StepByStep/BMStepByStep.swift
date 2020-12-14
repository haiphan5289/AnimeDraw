//
//  BMStepByStep.swift
//  AnimeDraw
//
//  Created by paxcreation on 12/14/20.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import ViewAnimator
import SnapKit

class BMStepByStep: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @VariableReplay private var listStep: [StepModel] = []
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.visualize()
        self.setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}
extension BMStepByStep {
    private func visualize() {
        tableView.delegate = self
        tableView.register(BMStepCell.nib, forCellReuseIdentifier: BMStepCell.identifier)
        self.listStep = RealmManage.share.getStepByStep()
    }
    private func setupRX() {
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: PushNotificationKeys.addStep.rawValue))
            .asObservable()
            .bind { [weak self] (notify) in
                guard let wSelf = self else {
                    return
                }
                wSelf.listStep = RealmManage.share.getStepByStep()
            }.disposed(by: disposeBag)
        
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
extension BMStepByStep: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
