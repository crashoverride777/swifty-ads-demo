import UIKit
import SpriteKit
import GoogleMobileAds
import SwiftyAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let swiftyAds: SwiftyAdsType = SwiftyAds.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let gameViewController = window?.rootViewController as? GameViewController {
            configureSwiftyAds(from: gameViewController)
        }
        return true
    }
}

// MARK: - Private Methods

private extension AppDelegate {
    
    func configureSwiftyAds(from gameViewController: GameViewController) {
        #if DEBUG
        let environment: SwiftyAdsEnvironment = .development(
            testDeviceIdentifiers: [],
            consentConfiguration: .resetOnLaunch(geography: .EEA)
        )
        #else
        let environment: SwiftyAdsEnvironment = .production
        #endif
        swiftyAds.configure(
            from: gameViewController,
            for: environment,
            requestBuilder: SwiftyAdsRequestBuilder(),
            mediationConfigurator: SwiftyAdsMediationConfigurator(),
            bundlePlist: .main,
            completion: {
                gameViewController.adsConfigureCompletion()
            }
        )
        
        swiftyAds.observeConsentStatus { newStatus in
            switch newStatus {
            case .notRequired:
                print("SwiftyAds did change consent status: notRequired")
            case .required:
                print("SwiftyAds did change consent status: required")
            case .obtained:
                print("SwiftyAds did change consent status: obtained")
            case .unknown:
                print("SwiftyAds did change consent status: unknown")
            @unknown default:
                print("SwiftyAds did change consent status: unknown default")
            }
        }
    }
}

// MARK: - SwiftyAdsRequestBuilder

private final class SwiftyAdsRequestBuilder: SwiftyAdsRequestBuilderType {
    func build() -> GADRequest {
        GADRequest()
    }
}

// MARK: - SwiftyAdsMediationConfiguratorType

private final class SwiftyAdsMediationConfigurator: SwiftyAdsMediationConfiguratorType {
    func updateCOPPA(isTaggedForChildDirectedTreatment: Bool) {
        print("SwiftyAdsMediationConfigurator update COPPA", isTaggedForChildDirectedTreatment)
    }
    
    func updateGDPR(for consentStatus: SwiftyAdsConsentStatus, isTaggedForUnderAgeOfConsent: Bool) {
        print("SwiftyAdsMediationConfigurator update GDPR")
    }
}
