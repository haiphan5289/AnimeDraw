//
//  TutorialsVC.swift
//  AnimeDraw
//
//  Created by haiphan on 12/5/20.
//

import UIKit
import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import ViewAnimator
import SnapKit

class TutorialsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var listAnime: PublishSubject<[StepModel]> = PublishSubject.init()
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
extension TutorialsVC {
    private func visualize() {
        collectionView.delegate = self
        collectionView.register(StepCell.nib, forCellWithReuseIdentifier: StepCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        title = "Tutorials"
        self.navigationItem.title = "Tutorials"
    }
    private func setupRX() {
        self.listAnime.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: StepCell.identifier, cellType: StepCell.self)) { row, data, cell in
                cell.lbName.text = data.text
                cell.lbName.sizeToFit()
                cell.img.image = UIImage(named: data.image ?? "")
            }.disposed(by: disposeBag)
        
        ReadJSON.shared.readJSONObs(offType: [StepModel].self, name: "Tutorials", type: TypeJSON.json.rawValue)
            .subscribe { [weak self] (result) in
                guard let wSelf = self else {
                    return
                }
                switch result {
                case .success(let data):
                    wSelf.listAnime.onNext(data)
                case .failure(let err):
                    print("\(err)")
                }
            } onError: { (err) in
                print("\(err.localizedDescription)")
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.bind { [weak self] (idx) in
            guard let wSelf = self else {
                return
            }
            let vc = StepDetail(nibName: "StepDetail", bundle: nil)
            wSelf.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
}
extension TutorialsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.bounds.width - 30) / 2 , height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.reloadData()
    }
}

