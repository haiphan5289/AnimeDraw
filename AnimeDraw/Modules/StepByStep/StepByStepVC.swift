//
//  StepByStepVC.swift
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

class StepByStepVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.visualize()
        self.setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}
extension StepByStepVC {
    private func visualize() {
        collectionView.delegate = self
        collectionView.register(StepCell.nib, forCellWithReuseIdentifier: StepCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    private func setupRX() {
        Observable.just([1,2,3])
            .bind(to: collectionView.rx.items(cellIdentifier: StepCell.identifier, cellType: StepCell.self)) { row, data, cell in
                cell.backgroundColor = (row % 2 == 0) ? .red : .blue
            }.disposed(by: disposeBag)
    }
}
extension StepByStepVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.bounds.width - 30) / 2 , height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.reloadData()
    }
}
