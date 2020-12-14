//
//  BookMarksTutorial.swift
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

class BookMarksTutorial: UIViewController {

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
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
extension BookMarksTutorial {
    private func visualize() {
        tableView.delegate = self
        tableView.register(BMStepCell.nib, forCellReuseIdentifier: BMStepCell.identifier)
        self.listStep = RealmManage.share.getTutorial()
    }
    private func setupRX() {
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: PushNotificationKeys.addTutorial.rawValue))
            .asObservable()
            .bind { [weak self] (notify) in
                guard let wSelf = self else {
                    return
                }
                wSelf.listStep = RealmManage.share.getTutorial()
            }.disposed(by: disposeBag)
        
        self.$listStep.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: BMStepCell.identifier, cellType: BMStepCell.self)) {(row, element, cell) in
                cell.lbTitle.text = element.text
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { [weak self] (idx) in
            guard let wSelf = self else {
                return
            }
            let vc = DisplayTutorialVC(nibName: "DisplayTutorialVC", bundle: nil)
            let item = wSelf.listStep[idx.row]
            vc.anime = item
            vc.hidesBottomBarWhenPushed = true
            wSelf.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
}
extension BookMarksTutorial: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
