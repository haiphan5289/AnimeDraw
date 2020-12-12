//
//  StepDetail.swift
//  AnimeDraw
//
//  Created by haiphan on 12/11/20.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class StepDetail: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @VariableReplay private var listAnime: [StepModel] = []
    private let disposeBag = DisposeBag()
    var titleAnime: String = ""
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
extension StepDetail {
    private func visualize() {
        collectionView.delegate = self
        collectionView.register(StepDetailCell.nib, forCellWithReuseIdentifier: StepDetailCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.isPagingEnabled = true
        title = "Step by Step"
        self.navigationItem.title = self.titleAnime
    }
    private func setupRX() {
        self.$listAnime.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: StepDetailCell.identifier, cellType: StepDetailCell.self)) { row, data, cell in
                cell.img.image = UIImage(named: data.image ?? "")
                cell.lbTitle.text = data.text
                cell.hTitle.constant = (data.text ?? "").getTextSizeNoteView(fontSize: 15, width: self.view.bounds.width, height: 1000).height + 50
            }.disposed(by: disposeBag)
        
        ReadJSON.shared.readJSONObs(offType: [StepModel].self, name: self.titleAnime, type: TypeJSON.json.rawValue)
            .subscribe { [weak self] (result) in
                guard let wSelf = self else {
                    return
                }
                switch result {
                case .success(let data):
                    wSelf.listAnime = data
                    wSelf.pageControl.currentPage = 0
                    wSelf.pageControl.numberOfPages = data.count
                case .failure(let err):
                    print("\(err)")
                }
            } onError: { (err) in
                print("\(err.localizedDescription)")
            }.disposed(by: disposeBag)
        
        
        
    }
}
extension StepDetail: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView.bounds.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
}
