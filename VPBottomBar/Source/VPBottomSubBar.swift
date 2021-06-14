//
//  VPBottomSubBar.swift
//  VPBottomBar
//
//  Created by Vicky Prajapati on 11/06/21.
//

import UIKit

class VPBottomSubBar: UIView {

    // UI Control
//    let containerView: UIView = {
//        let containerView = UIView()
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        return containerView
//    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCenterLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
        collectionView.register(BottomBarCell.self, forCellWithReuseIdentifier: "BottomBarCell")
        return collectionView
    }()
    
    // Properties
    @objc open var arrBottomNavItem: [BottomNavItem] = [BottomNavItem]()
    @objc open var bottomBarHeight: CGFloat = 50
    @objc open var numberOfItemsInRow: Int = 5
    
    @objc weak var objVPBottomSubBarProtocolDelegate: VPBottomSubBarProtocol?
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addObserver() {
        self.removeObserver()
        self.collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserver() {
        if self.collectionView.observationInfo != nil {
            self.collectionView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UICollectionView {
            if obj == self.collectionView && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    //do stuff here
                    objVPBottomSubBarProtocolDelegate?.bottomNavSubBarGridViewContentHeightChange?(newSize.height)
                }
            }
        }
    }
    
    deinit {
        self.removeObserver()
    }
    
    // Custom Methods
    func setupUI() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewCenterLayout {
            let width = UIScreen.main.bounds.size.width / CGFloat(numberOfItemsInRow)
    //        layout.estimatedItemSize = CGSize(width: width, height: bottomBarHeight)
            layout.itemSize = CGSize(width: width, height: bottomBarHeight)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        containerView.addSubview(collectionView)
        self.addSubview(collectionView)
        self.setupConstraints()
    }
    
    func setupConstraints() {
        // ContainerView
//        let leadingConstraint = NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: collectionView, attribute: .leading, multiplier: 1, constant: 0)
//        let trailingConstraint = NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: collectionView, attribute: .trailing, multiplier: 1, constant: 0)
//        let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottomMargin, relatedBy: .equal, toItem: collectionView, attribute: .bottomMargin, multiplier: 1, constant: 0)
//        let heightConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 0)
//        self.addConstraints([leadingConstraint, trailingConstraint, bottomConstraint, heightConstraint])
        
        // Collectionview
        let leadingConstraint1 = NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint1 = NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint1 = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint1 = NSLayoutConstraint(item: collectionView, attribute: .bottomMargin, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: 0)
        self.addConstraints([leadingConstraint1, trailingConstraint1, topConstraint1, bottomConstraint1])
    }
    
    @objc open func loadBottomSubBarWith(arrBottomNavItem: [BottomNavItem]) {
        self.arrBottomNavItem = arrBottomNavItem
        self.setupUI()
        self.addObserver()
        self.collectionView.reloadData()
    }
}

extension VPBottomSubBar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBottomNavItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomBarCell", for: indexPath) as! BottomBarCell
        cell.objBottomNavItem =  self.arrBottomNavItem[indexPath.item]
//        cell.contentView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.objVPBottomSubBarProtocolDelegate?.bottomNavSubBarItemClicked?(self.arrBottomNavItem[indexPath.item])
    }
}
