//
//  AdsTableViewController.swift
//  HeiAd
//
//  Created by Reinhard D on 20.10.21.
//

import UIKit
import SDWebImage

class AdsTableViewController: UITableViewController {
    
    @IBOutlet weak var faveToggleButton: UIBarButtonItem!
    
    var adObjects = [AdObject]()
    
    var showsFavorite:Bool = false
    
    let heartFullImage = UIImage(systemName: "heart.fill")
    let heartClear = UIImage(systemName: "heart")
    
    let tableIcon = UIImage(systemName: "list.dash")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HEI FINN"
        
        self.adObjects = CoreDataManager.shared.fetchAds(onlyFaves: false)!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return adObjects.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdCell", for: indexPath)
        as! AdCell
        
        let item = adObjects[indexPath.row]
        
        cell.titleText?.text = item.descriptionInfo
        
        let krFormatter = NumberFormatter()
        krFormatter.usesGroupingSeparator = true
        krFormatter.numberStyle = .currency
        krFormatter.maximumFractionDigits = 0
        krFormatter.locale = NSLocale(localeIdentifier: "nb_NO") as Locale
        
        let priceString = krFormatter.string(from: NSNumber(value: item.price))!
        
        cell.priceText?.text = priceString
        cell.priceText?.layer.cornerRadius = 8.0
        
        cell.locationText?.text = item.location
        cell.faveButton.tag = indexPath.row
        
        if(item.favorite){
            
            cell.faveButton.setImage(heartFullImage, for: .normal)
            
        }else{
            cell.faveButton.setImage(heartClear, for: .normal)
        }
        
        cell.adImage.sd_setImage(with: URL(string: item.url!), placeholderImage: UIImage(named: "Placeholder"))
        
        cell.adImage.layer.cornerRadius = 20.0
        
        
        return cell
    }
    
    
    @IBAction func faveAction(_ sender: UIButton) {
        
        let item = adObjects[sender.tag]
            
            if(item.favorite){
                CoreDataManager.shared.updateAds(adId: item.id!, favorite: false)
            }else{
                CoreDataManager.shared.updateAds(adId: item.id!, favorite: true)
            }
            
            if(showsFavorite){
                self.adObjects = CoreDataManager.shared.fetchAds(onlyFaves: showsFavorite)!
            }
            
            self.tableView.reloadData()
            
        
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        
        if let url = URL(string: "https://www.finn.no/job/fulltime/ad.html?finnkode=233670552") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func showOnlyFaves(_ sender: Any) {
        
        if(showsFavorite){
            showsFavorite = false
            self.faveToggleButton.image = heartFullImage
            
        }else{
            showsFavorite = true
            self.faveToggleButton.image = tableIcon
        }
        
        self.adObjects = CoreDataManager.shared.fetchAds(onlyFaves: showsFavorite)!
        self.tableView.reloadData()
    }
    
}





