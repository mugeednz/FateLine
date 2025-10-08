//
//  Global Helper.swift
//  fateline
//
//  Created by Müge Deniz on 8.10.2025.
//
import Foundation
import SafariServices
import StoreKit


final class GlobalHelper {
    static let shared = GlobalHelper()
 
    static func isPremiumActive() -> Bool {
        var isPremium: Bool = false
        Subscription.instance.isActive { premium in
            isPremium = premium
        }
        return isPremium
    }
    
    static func pushController<VC: UIViewController>(isAnimatedActive: Bool = true, id: String, _ vC: UIViewController, setup: (_ vc: VC) -> ()) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id) as? VC {
            setup(vc)
            vC.navigationController?.pushViewController(vc, animated: isAnimatedActive)
        }
    }
    
    static func presentController<VC: UIViewController>(id: String, from vC: UIViewController, setup: (_ vc: VC) -> ()) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id) as? VC {
            setup(vc)
            vC.present(vc, animated: true, completion: nil)
        }
    }
    
    static func openPrivacy(_ vc: UIViewController) {
        openLinkInSafari(vc, url: "")  //DEGISTI
    }
    
    static func openTerms(_ vc: UIViewController) {
        openLinkInSafari(vc, url: "")
    }
    
    static func openContact(_ vc: UIViewController) {
        openLinkInSafari(vc, url: "")
    }
    
    static func openSubs(vC: UIViewController) {
//        let premiumVC = PremiumViewController()
//        let nav = UINavigationController(rootViewController: premiumVC)
//        nav.modalPresentationStyle = .fullScreen
//        vC.present(nav, animated: true)
    }
    
    static func openSettings (vc: UIViewController) {
//        let settingsVC = SettingsViewController()
//        let nav = UINavigationController(rootViewController: settingsVC)
//        nav.modalPresentationStyle = .fullScreen
//        vc.present(nav, animated: true)
    }
    
    static func openLinkInSafari(_ vc: UIViewController, url: String) {
        guard let url = URL(string: url) else { return }
        let svc = SFSafariViewController(url: url)
        svc.overrideUserInterfaceStyle = .dark
        vc.present(svc, animated: true, completion: nil)
    }
    
    static func rateApp() {
        UserDefaults.standard.set(true, forKey: "hasSeenRatePopup")
        UserDefaults.standard.synchronize()
        SKStoreReviewController.requestReview()
    }
    
}

import JGProgressHUD

extension GlobalHelper {
    static var HUD: JGProgressHUD!

    static func hudShow(_ vc: UIViewController, withText text: String = "Loading") {
        GlobalHelper.HUD = JGProgressHUD(style: .dark)
        GlobalHelper.HUD.textLabel.text = text
        GlobalHelper.HUD.indicatorView = JGProgressHUDPieIndicatorView()
        GlobalHelper.HUD.show(in: vc.view)
    }

    static func hudProgress(_ progress: Float) {
        GlobalHelper.HUD.progress = progress
    }

    static func hudDismiss() {
        GlobalHelper.HUD.progress = 0.0
        GlobalHelper.HUD.dismiss()
    }
}
