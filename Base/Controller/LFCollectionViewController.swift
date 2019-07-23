//
//  LFCollectionViewController.swift
//  gct
//
//  Created by SADF on 2019/2/18.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFCollectionViewController: LFBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView: MyCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    func neededCollectionViewDirection(_ direction: UICollectionView.ScrollDirection) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = (direction)
        
        collectionView = MyCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
//        collectionView.mas_makeConstraints({ make in
//            make.edges.insets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        })
        self.collectionView.snp_makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        })
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    

}
