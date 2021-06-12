//
//  VPBottomBarProtocol.swift
//  VPBottomBar
//
//  Created by Vicky Prajapati on 11/06/21.
//

import UIKit
import Foundation

@objc public protocol VPBottomBarProtocol {
    @objc optional func bottomNavBarItemClicked(_ objBottomNavItem: BottomNavItem)

    @objc optional func bottomNavBarWillOpen()
    
    @objc optional func bottomNavBarDidOpen()

    @objc optional func bottomNavBarWillClose()
    
    @objc optional func bottomNavBarDidClose()
}

@objc public protocol VPBottomSubBarProtocol {
    @objc optional func bottomNavSubBarItemClicked(_ objBottomNavItem: BottomNavItem)

    @objc optional func bottomNavSubBarGridViewContentHeightChange(_ height: CGFloat)
}
