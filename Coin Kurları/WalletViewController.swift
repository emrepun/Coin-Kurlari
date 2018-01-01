//
//  WalletViewController.swift
//  Coin Kurları
//
//  Created by Emre HAVAN on 23.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import GoogleMobileAds

class WalletViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var bannerView: GADBannerView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var addButton: UIBarButtonItem!
    var tlDollarWorth = ""
    var tlEuroWorth = ""
    var tlCoinWorth = ""
    let connectionError = "İnternete bağlı olduğunuzdan emin olunuz. Eğer internet bağlantınız olmasına rağmen sorun yaşıyorsanız, lütfen destekle iletişime geçiniz."
    
    var coinInfos = [CoinToGo]()
    var coins = [Crypto]()
    
    var pickerInputs = ["bitcoin", "ethereum", "bitcoin-cash", "ripple", "litecoin", "cardano", "iota", "dash", "nem", "monero", "bitcoin-gold", "eos", "stellar", "ethereum-classic", "qtum", "neo", "tron", "lisk", "verge", "bitconnect", "zcash", "siacoin", "nxt", "dogecoin", "ark"]
    var picker = UIPickerView()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isEnabled = false
        picker.delegate = self
        picker.dataSource = self
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        myAlertInputs()
        doConnect()
        
        let request = GADRequest()
        bannerView.adUnitID = "ca-app-pub-9102512487367812/3495048221"
        bannerView.rootViewController = self
        bannerView.load(request)
    }

    let alert = UIAlertController(title: "Coin Ekle", message: nil, preferredStyle: .alert)
    
    func myAlertInputs() {
        
        alert.addTextField { (textField) in
            textField.placeholder = "Coin Seçiniz."
            textField.inputView = self.picker
            textField.delegate = self
            textField.tag = 1
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Miktar Giriniz."
            textField.keyboardType = .decimalPad
        }
        
        let action = UIAlertAction(title: "Ekle", style: .default) { (_) in
            let coinName = self.alert.textFields!.first!.text!
            let coinAmount = (String(self.alert.textFields!.last!.text!.formatValue)).doubleValue
            if coinAmount > 0, coinName.count > 0, self.pickerInputs.contains(coinName) {
                let crypto = Crypto(context: PersistenceService.context)
                crypto.coinAmount = coinAmount
                crypto.coinName = coinName
                PersistenceService.saveContext()
                self.coins.append(crypto)
                self.tableView.reloadData()
            } else {
                self.showAlert(title: "Lütfen geçerli bir coin seçiniz.", message: "Lütfen geçerli bir coin seçiniz ve miktarı doğru giriniz.")
            }
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    }
    
    @IBAction func addCoinTapped(_ sender: Any) {
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerInputs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerInputs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        alert.textFields!.first!.text! = pickerInputs[row]
    }
    
    //MARK: Connection to apis to get coin info & currency rates. - Api bağlantısı, coin bilgileri ve kur bilgilerini çekiyoruz.
    func doConnect() {
        let coinUrl = "https://api.coinmarketcap.com/v1/ticker/"
        Alamofire.request(coinUrl, method: .get).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                for i in 0..<100 {
                    
                    let json = JSON(value)
                    let myJson = json[i]
                    let myCoin = CoinToGo(name: myJson["name"].stringValue, price_usd: myJson["price_usd"].stringValue, percent_change_24h: myJson["percent_change_24h"].stringValue, id: myJson["id"].stringValue)
                    self.coinInfos.append(myCoin)
                    
                }
                self.getDollarRate()
                
            case .failure( _):
                self.showAlert(title: "Bağlantı Sorunu", message: self.connectionError)
            }
        }
    }
    
    func getDollarRate() {
        
        let dollarUrl = "https://doviz.com/api/v1/currencies/USD/latest"
        Alamofire.request(dollarUrl, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.tlDollarWorth = String(Double(json["selling"].stringValue)!.yuvarla(basamak: 4))
                self.getEuroRate()
            case .failure( _):
                self.showAlert(title: "Bağlantı Sorunu", message: self.connectionError)
            }
        }
    }

    func getEuroRate() {
        let euroUrl = "https://doviz.com/api/v1/currencies/EUR/latest"
        Alamofire.request(euroUrl, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.tlEuroWorth = String(Double(json["selling"].stringValue)!.yuvarla(basamak: 4))

                //MARK: Fetch all the coins in the core data and refresh tableView thing.
                self.addButton.isEnabled = true
                self.activityIndicator.stopAnimating()
                let fetchRequest: NSFetchRequest<Crypto> = Crypto.fetchRequest()
                do {
                    let coin = try PersistenceService.context.fetch(fetchRequest)
                    self.coins = coin
                    self.tableView.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                }

            case .failure( _):
                self.showAlert(title: "Bağlantı Sorunu", message: self.connectionError)
            }
        }
    }
}


//MARK: Tableview extension for data source. - View'ımızı tableview'a datasource sağlayıcısı haline getiriyoruz.
extension WalletViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            PersistenceService.context.delete(self.coins[indexPath.row])
            PersistenceService.saveContext()
            self.coins.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = .lightGray
        
        for i in coinInfos {
            if i.id == coins[indexPath.row].coinName {
                
                let dollarValue = (Double(i.price_usd)! * coins[indexPath.row].coinAmount).yuvarla(basamak: 2)
                let tlValue = (dollarValue * Double(self.tlDollarWorth)!).yuvarla(basamak: 2)
                let euroValue = (tlValue / Double(self.tlEuroWorth)!).yuvarla(basamak: 2)
                cell.textLabel!.text = "\(String(coins[indexPath.row].coinName!)) Miktarı: \(coins[indexPath.row].coinAmount)"
                cell.detailTextLabel!.text = "₺: \(String(tlValue))      $: \(String(dollarValue))     €:\(String(euroValue))"

                return cell
            }
            
        }
        self.tableView.reloadData()

        return cell
    }
    
    
    
}
















