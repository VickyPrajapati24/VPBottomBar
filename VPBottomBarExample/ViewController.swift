//
//  ViewController.swift
//  VPBottomBarExample
//
//  Created by Vicky Prajapati on 12/06/21.
//

import UIKit
import WebKit
import VPBottomBar

class ViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var bottomBar: VPBottomBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        self.loadWebView()
        
        bottomBar.objVPBottomBarProtocolDelegate = self
        var arrBottomNavItem = [BottomNavItem]()
        arrBottomNavItem.append(BottomNavItem.init(imageTitle: "Home", imageName: "home"))
        arrBottomNavItem.append(BottomNavItem.init(imageTitle: "Chart", imageName: "chart"))
        arrBottomNavItem.append(BottomNavItem.init(imageTitle: "Help", imageName: "help"))
        arrBottomNavItem.append(BottomNavItem.init(imageTitle: "Quit", imageName: "logout"))
        arrBottomNavItem.append(BottomNavItem.init(imageTitle: "Sync", imageName: "sync"))
        arrBottomNavItem.append(BottomNavItem.init(imageTitle: "Chart1", imageName: "chart"))
        arrBottomNavItem.append(BottomNavItem.init(imageTitle: "Help1", imageName: "help"))
        arrBottomNavItem.append(BottomNavItem.init(imageTitle: "Quit1", imageName: "logout"))
        arrBottomNavItem.append(BottomNavItem.init(imageTitle: "Sync1", imageName: "sync"))
        arrBottomNavItem.append(BottomNavItem.init(imageTitle: "Chart2", imageName: "chart"))
        arrBottomNavItem.append(BottomNavItem.init(imageTitle: "Help2", imageName: "help"))
        
        bottomBar.loadBottomBarWith(arrBottomNavItem: arrBottomNavItem)
    }
    
    func loadWebView() {
        webView.navigationDelegate = self
        
        let url = URL(string: "https://github.com/VickyPrajapati24/VickyPrajapati24/blob/main/README.md")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

extension ViewController: VPBottomBarProtocol {
    func bottomNavBarWillOpen() {
        print("BottomNavBar will open")
    }
    
    func bottomNavBarDidOpen() {
        print("BottomNavBar did open")
    }
    
    func bottomNavBarWillClose() {
        print("BottomNavBar will close")
    }
    
    func bottomNavBarDidClose() {
        print("BottomNavBar did close")
    }
    
    func bottomNavBarItemClicked(_ objBottomNavItem: BottomNavItem) {
        print(objBottomNavItem.imageTitle)
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
