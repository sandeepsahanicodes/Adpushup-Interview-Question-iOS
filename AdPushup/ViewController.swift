//
//  ViewController.swift
//  AdPushup
//
//  Created by Sandeep Sahani on 30/04/24.
//

import UIKit
import GoogleMobileAds
class ViewController: UIViewController {
    
    @IBOutlet weak var clickHereBtn: UIButton!
    
    private var rewardedAd: GADRewardedAd?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadRewardedAd() {
        Task{
            do {
                rewardedAd = try await GADRewardedAd.load(
                    withAdUnitID: "/6499/example/rewarded", request: GAMRequest())
                rewardedAd?.fullScreenContentDelegate = self
                
            } catch {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "AdPushup", message: "Do you want to See Ad?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            // print("Yes!")
            self.show()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            // print("No!")
            alertController.dismiss(animated: true)
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func show() {
      guard let rewardedAd = rewardedAd else {
          adNotPresent()
          return print("Ad wasn't ready.")
      }

      // The UIViewController parameter is an optional.
      rewardedAd.present(fromRootViewController: self) {
        
          print("Reward received with currency \(rewardedAd.adReward.amount), amount \(rewardedAd.adReward.type)")
        // TODO: Reward the user.
      }
    }

    func adNotPresent() {
        let alert = UIAlertController(title: "AdsPushup",
                                      message: "Ads Not Avalilable",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in
             print("OK tap")
        }))

        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: GADFullScreenContentDelegate {
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
        Task {
            loadRewardedAd()
        }
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd)  {
        print("Ad did dismiss full screen content.")
       
    }
}

