//
//  ViewController.swift
//  HeiAd
//
//  Created by Reinhard D on 20.10.21.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var meView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HeiAd!"
        
        self.startButton.layer.cornerRadius = 15.0
        meView.layer.borderWidth = 5.0
        meView.layer.masksToBounds = false
        meView.layer.borderColor = UIColor.white.cgColor
        meView.layer.cornerRadius =  meView.frame.size.width / 2
        meView.clipsToBounds = true
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = UIColor(hexString: "#0ab4ed")
        
        barAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.standardAppearance = barAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
    
        self.navigationController?.navigationBar.tintColor  = .white
        self.navigationController?.navigationBar.barTintColor  = .white
        
        if Reachability.isConnectedToNetwork(){
            
            AdDataRequest().execute(completion: { message in
                
                if message == "SUCCESS" {
                    print("Ads downloaded")
                }
            })
        }else{
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            self.moveImageView(imgView: self.logoView)
            self.setAlpha1(buttonView: self.startButton)
            self.setAlpha(imgView: self.meView)

        }
    }
    
    
    @IBAction func showAdsTableViewController(_ sender: Any) {
        
        let displayVC : AdsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdsTableViewController") as! AdsTableViewController
        
        self.navigationController?.pushViewController(displayVC, animated: true)
    }
    
    func setAlpha(imgView: UIImageView) {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIView.AnimationOptions.curveLinear, animations: {
            imgView.alpha = 1
        }, completion: { (finished: Bool) in
           
        });
    }
    
    func setAlpha1(buttonView: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.7, options: UIView.AnimationOptions.curveLinear, animations: {
            buttonView.alpha = 1
        }, completion: { (finished: Bool) in
            
        });
    }
    
    func moveImageView(imgView: UIImageView) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            imgView.frame.origin.y = -10
        }, completion: { (finished: Bool) in
            
        });
        
    }
}


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
