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
    @VariableReplay private var listStep: [StepModel] = []
    private let disposeBag = DisposeBag()
    var anime: StepModel?
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
        self.navigationItem.title = self.anime?.text
        
        let btPlus: UIButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        btPlus.setImage(UIImage(systemName: "plus"), for: .normal)
        btPlus.setTitleColor(.black, for: .normal)
        btPlus.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let rightBarButton = UIBarButtonItem(customView: btPlus)
        navigationItem.rightBarButtonItem = rightBarButton
        btPlus.rx.tap.bind { [weak self] _ in
            guard let wSelf = self, let item = wSelf.anime else {
                return
            }
            wSelf.showAlert(msg: "Do you want to add in BookMarks", buttonTitle: ["Cancel", "OK"]) { (index) in
                if index == 1 {
                    RealmManage.share.addStep(model: item)
                }
            }
            
        }.disposed(by: disposeBag)
        
        self.listStep = RealmManage.share.getStepByStep()
        
        self.$listStep.asObservable().bind { [weak self] (l) in
            guard let wSelf = self, let anime = wSelf.anime else {
                return
            }
            for i in l where i.text == anime.text {
                btPlus.isHidden = true
            }
        }.disposed(by: disposeBag)
    }
    private func setupRX() {
        self.$listAnime.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: StepDetailCell.identifier, cellType: StepDetailCell.self)) { row, data, cell in
                let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
                              NSAttributedString.Key.foregroundColor : UIColor.black]
                let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                              NSAttributedString.Key.foregroundColor : UIColor.black]
                let attributedString1 = NSMutableAttributedString(string:"Step \(row + 1): ", attributes:attrs1)
                let attributedString2 = NSMutableAttributedString(string:data.text ?? "", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                cell.lbTitle.attributedText = attributedString1
                cell.img.image = UIImage(named: data.image ?? "")
                cell.hTitle.constant = (data.text ?? "").getTextSizeNoteView(fontSize: 15, width: self.view.bounds.width, height: 1000).height + 50
            }.disposed(by: disposeBag)
        
        guard let title = self.anime?.text else {
            return
        }
        
        ReadJSON.shared.readJSONObs(offType: [StepModel].self, name: title, type: TypeJSON.json.rawValue)
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
