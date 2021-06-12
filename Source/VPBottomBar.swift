//
//  VPBottomBar.swift
//  VPBottomBar
//
//  Created by Vicky Prajapati on 11/06/21.
//

import UIKit

open class BottomNavItem: NSObject {
    @objc open var imageTitle = String()
    @objc open var imageName = String()
    @objc open var isMoreMenuItem: Bool = false
    
    @objc public init(imageTitle: String, imageName: String) {
        self.imageTitle = imageTitle
        self.imageName = imageName
    }
}

open class VPBottomBar: UIView {
    
    // UI Control
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCenterLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(BottomBarCell.self, forCellWithReuseIdentifier: "BottomBarCell")
        return collectionView
    }()
    
    let objVPBottomSubBar: VPBottomSubBar = {
        let objVPBottomSubBar = VPBottomSubBar.init()
        objVPBottomSubBar.translatesAutoresizingMaskIntoConstraints = false
        objVPBottomSubBar.backgroundColor = .white
        objVPBottomSubBar.clipsToBounds = true
        objVPBottomSubBar.layer.cornerRadius = 20
        objVPBottomSubBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        objVPBottomSubBar.alpha = 0
        return objVPBottomSubBar
    }()
    
    // Overlay
    let overlayView : UIControl = {
        let overlayView = UIControl.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.alpha = 0
        overlayView.isUserInteractionEnabled = true
        return overlayView
    }()
    
    // Properties
    @objc open var arrBottomNavItem: [BottomNavItem] = [BottomNavItem]()
    
    @objc open var bottomBarHeight: CGFloat = 50
    @objc open var defaultMoreIconIndex: Int = 2
    @objc open var numberOfItemsInRow: Int = 5
    
    var heightConstraint3 = NSLayoutConstraint()
    
    // bar status
    open var closed: Bool = true
    
    @objc open weak var objVPBottomBarProtocolDelegate: VPBottomBarProtocol?
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        bottomBarHeight = frame.size.height
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bottomBarHeight = frame.size.height
    }
    
    // Custom Methods
    func setupUI() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewCenterLayout {
            let itemCount = arrBottomNavItem.count > numberOfItemsInRow ? numberOfItemsInRow : arrBottomNavItem.count
            let width = UIScreen.main.bounds.size.width / CGFloat(itemCount)
    //        layout.estimatedItemSize = CGSize(width: width, height: bottomBarHeight)
            layout.itemSize = CGSize(width: width, height: bottomBarHeight)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.addSubview(collectionView)
        self.superview?.addSubview(objVPBottomSubBar)
        self.superview?.addSubview(overlayView)
        overlayView.addTarget(self, action: #selector(close), for: UIControl.Event.touchUpInside)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        // Collectionview
        let leadingConstraint2 = NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint2 = NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint2 = NSLayoutConstraint(item: collectionView, attribute: .bottomMargin, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: 0)
        let heightConstraint2 = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.bottomBarHeight)
        self.addConstraints([leadingConstraint2, trailingConstraint2, bottomConstraint2, heightConstraint2])
        
        // objVPBottomSubBar
        let leadingConstraint3 = NSLayoutConstraint(item: objVPBottomSubBar, attribute: .leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint3 = NSLayoutConstraint(item: objVPBottomSubBar, attribute: .trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint3 = NSLayoutConstraint(item: objVPBottomSubBar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        heightConstraint3 = NSLayoutConstraint(item: objVPBottomSubBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 0)
        heightConstraint3.isActive = true
        self.superview?.addConstraints([leadingConstraint3, trailingConstraint3, bottomConstraint3, heightConstraint3])
    }
    
    @objc open func loadBottomBarWith(arrBottomNavItem: [BottomNavItem]) {
        self.arrBottomNavItem = arrBottomNavItem
        if self.arrBottomNavItem.count > numberOfItemsInRow {
            let objBottomNavItem = BottomNavItem.init(imageTitle: "Open", imageName: "open")
            objBottomNavItem.isMoreMenuItem = true
            self.arrBottomNavItem.insert(objBottomNavItem, at: defaultMoreIconIndex)
        }
        self.setupUI()
        self.collectionView.reloadData()
        
        objVPBottomSubBar.objVPBottomSubBarProtocolDelegate = self
        
        if self.arrBottomNavItem.count > numberOfItemsInRow {
            let arrBottomSubNavItem = Array(self.arrBottomNavItem[numberOfItemsInRow...])
            objVPBottomSubBar.loadBottomSubBarWith(arrBottomNavItem: arrBottomSubNavItem)
        }
    }
    
    // toggle and open/close methods
    @objc open func toggle() {
        if closed == true {
            open()
        } else {
            close()
        }
    }
    
    @objc open func open() {
        self.setMenuSelectDeselect()
        
        self.objVPBottomBarProtocolDelegate?.bottomNavBarWillOpen?()
        
        let animationGroup = DispatchGroup()
        
        self.superview?.bringSubviewToFront(overlayView)
        self.superview?.bringSubviewToFront(self.objVPBottomSubBar)
        self.superview?.bringSubviewToFront(self)
        
        animationGroup.enter()
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 0.3,
                       options: UIView.AnimationOptions(), animations: { () -> Void in
                        self.overlayView.alpha = 1
                       }, completion: {(f) -> Void in
                        animationGroup.leave()
                       })
        
        slideUpAnimationWithOpen(group: animationGroup)
        
        animationGroup.notify(queue: .main) {
            self.objVPBottomBarProtocolDelegate?.bottomNavBarDidOpen?()
        }
        
        closed = false
    }
    
    @objc open func close() {
        self.setMenuSelectDeselect()

        self.objVPBottomBarProtocolDelegate?.bottomNavBarWillClose?()
        let animationGroup = DispatchGroup()
        
        animationGroup.enter()
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.8,
                       options: [], animations: { () -> Void in
                        self.overlayView.alpha = 0
                       }, completion: {(f) -> Void in
                        animationGroup.leave()
                       })
        
        slideUpAnimationWithClose(group: animationGroup)
        
        animationGroup.notify(queue: .main) {
            self.objVPBottomBarProtocolDelegate?.bottomNavBarDidClose?()
        }
        
        closed = true
    }
    
    // Slide up open/close animation
    fileprivate func slideUpAnimationWithOpen(group: DispatchGroup) {
        group.enter()
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { () -> Void in
            self.objVPBottomSubBar.frame.origin.y -= self.heightConstraint3.constant
            self.objVPBottomSubBar.alpha = 1
        }, completion: { _ in
          group.leave()
        })
    }
    
    fileprivate func slideUpAnimationWithClose(group: DispatchGroup) {
        group.enter()
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { () -> Void in
            self.objVPBottomSubBar.frame.origin.y += self.heightConstraint3.constant
            self.objVPBottomSubBar.alpha = 0
        }, completion: { _ in
            self.superview?.sendSubviewToBack(self)
            self.superview?.sendSubviewToBack(self.objVPBottomSubBar)
            group.leave()
        })
    }
    
    func setMenuSelectDeselect() {
        if let cell = self.collectionView.cellForItem(at: IndexPath.init(item: self.defaultMoreIconIndex, section: 0)) as? BottomBarCell {
            let objBottomNavItem = self.arrBottomNavItem[defaultMoreIconIndex]
            objBottomNavItem.imageTitle = closed ? "Close" : "Open"
            objBottomNavItem.imageName = closed ? "close" : "open"
            cell.objBottomNavItem = objBottomNavItem
        }
    }
}

extension VPBottomBar: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBottomNavItem.count > numberOfItemsInRow ? numberOfItemsInRow : arrBottomNavItem.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomBarCell", for: indexPath) as! BottomBarCell
        cell.objBottomNavItem =  self.arrBottomNavItem[indexPath.item]
        cell.backgroundColor = .white
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objBottomNavItem = self.arrBottomNavItem[indexPath.item]
        if objBottomNavItem.isMoreMenuItem {
            toggle()
        } else {
            self.objVPBottomBarProtocolDelegate?.bottomNavBarItemClicked?(objBottomNavItem)
        }
    }
}

extension VPBottomBar: VPBottomSubBarProtocol {
    public func bottomNavSubBarGridViewContentHeightChange(_ height: CGFloat) {
        self.heightConstraint3.constant = height
        self.superview?.layoutIfNeeded()
    }
    
    public func bottomNavSubBarItemClicked(_ objBottomNavItem: BottomNavItem) {
        self.objVPBottomBarProtocolDelegate?.bottomNavBarItemClicked?(objBottomNavItem)
    }
}
