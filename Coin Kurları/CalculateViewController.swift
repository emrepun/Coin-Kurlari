//
//  CalculateViewController.swift
//  Coin Kurları
//
//  Created by Emre HAVAN on 23.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMobileAds

class CalculateViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    
@IBOutlet weak var bannerView: GADBannerView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var coins = [CoinToGo]()
    var dollarCoinWorth = ""
    var tlDollarWorth = ""
    var tlEuroWorth = ""
    let connectionError = "İnternete bağlı olduğunuzdan emin olunuz. Eğer internet bağlantınız olmasına rağmen sorun yaşıyorsanız, lütfen destekle iletişime geçiniz."
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var tlLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var euroLabel: UILabel!
    
    var picker = UIPickerView()
    var pickerInputs = ["bitcoin",
                        "ethereum",
                        "bitcoin-cash",
                        "ripple",
                        "litecoin",
                        "iota",
                        "cardano",
                        "dash",
                        "nem",
                        "monero",
                        "bitcoin-gold",
                        "eos",
                        "stellar",
                        "neo",
                        "qtum",
                        "ethereum-classic",
                        "verge",
                        "tron",
                        "lisk",
                        "bitconnect",
                        "zcash",
                        "nxt",
                        "waves",
                        "omisego",
                        "populous",
                        "bitshares",
                        "hshare",
                        "tether",
                        "ardor",
                        "stratis",
                        "komodo",
                        "bytecoin-bcn",
                        "augur",
                        "dogecoin",
                        "steem",
                        "siacoin",
                        "veritaseum",
                        "monacoin",
                        "ark",
                        "raiblocks",
                        "decred",
                        "salt",
                        "status",
                        "electroneum",
                        "digibyte",
                        "golem-network-tokens",
                        "pivx",
                        "binance-coin",
                        "bitcoindark",
                        "byteball",
                        "vechain",
                        "santiment",
                        "walton",
                        "tenx",
                        "power-ledger",
                        "bytom",
                        "maidsafecoin",
                        "reddcoin",
                        "basic-attention-token",
                        "qash",
                        "digixdao",
                        "factom",
                        "zcoin",
                        "vertcoin",
                        "aeternity",
                        "syscoin",
                        "kyber-network",
                        "0x",
                        "gas",
                        "gamecredits",
                        "bitbay",
                        "ethos",
                        "funfair",
                        "einsteinium",
                        "aion",
                        "dragonchain",
                        "cryptonex",
                        "civic",
                        "gxshares",
                        "decentraland",
                        "edgeless",
                        "iconomi",
                        "chainlink",
                        "nexus",
                        "gnosis-gno",
                        "monaco",
                        "raiden-network-token",
                        "request-network",
                        "ubiq",
                        "bancor",
                        "blocknet",
                        "metal",
                        "dent",
                        "time-new-bank",
                        "sonm",
                        "streamr-datacoin",
                        "substratum",
                        "nav-coin",
                        "centra",
                        "burst", ]

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        currencyTextField.inputView = picker
        
        let request = GADRequest()
        bannerView.adUnitID = "ca-app-pub-9102512487367812/3495048221"
        bannerView.rootViewController = self
        bannerView.load(request)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CalculateViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)

    }
    
    //MARK: Keyboard and pickerView thing.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerInputs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyTextField.text = pickerInputs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerInputs[row]
    }
    
    @objc func dismissKeyboard(tap: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
        currencyTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        currencyTextField.resignFirstResponder()
        return true
    }

    @IBAction func calculateButtonTapped(_ sender: Any) {
        getRates()
        
    }
    
    //MARK: Connection to apis to get coin info & currency rates. Api bağlantısı, coin bilgileri ve kur bilgilerini çekiyoruz.
    func getRates() {
        let url = "https://api.coinmarketcap.com/v1/ticker/\(currencyTextField.text!)/"
        activityIndicator.startAnimating()
        Alamofire.request(url, method: .get).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let jsonToGo = json[0]["price_usd"].stringValue
                if jsonToGo.count > 0 {
                    let myJson = String(Double(jsonToGo)!.yuvarla(basamak: 3))
                self.dollarCoinWorth = myJson
                self.getDollarRate()
                } else {
                    self.showAlert(title: "Hatalı Coin", message: "Lütfen geçerli bir coin seçiniz.")
                    self.activityIndicator.stopAnimating()
                }
                
                
            case .failure(let error):
                self.showAlert(title: "Bağlantı Sorunu", message: self.connectionError)
                print(error)
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
                print(self.tlDollarWorth)
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
                print(self.tlEuroWorth)
                self.writeLabels()
            case .failure( _):
                self.showAlert(title: "Bağlantı Sorunu", message: self.connectionError)
            }
        }
    }
    
    func writeLabels() {
        if (amountTextField?.text?.isEmpty)! {
            showAlert(title: "Gerekli Alanları Doldurunuz", message: "Lütfen gerekli alanları doldurduğunuzdan emin olunuz.")
            activityIndicator.stopAnimating()
        } else {
            self.dollarLabel.text = "\(String((amountTextField.text!.formatValue * self.dollarCoinWorth.doubleValue).yuvarla(basamak: 3))) $"
            let tlValue = (self.dollarCoinWorth.doubleValue * self.tlDollarWorth.doubleValue).yuvarla(basamak: 3)
            let euroValue = (tlValue / self.tlEuroWorth.doubleValue).yuvarla(basamak: 3)
            print(tlValue)
            print(euroValue)
            self.tlLabel.text = "\(String((amountTextField.text!.formatValue * tlValue).yuvarla(basamak: 3))) ₺"
            self.euroLabel.text = "\(String((amountTextField.text!.formatValue * euroValue).yuvarla(basamak: 3))) €"
            activityIndicator.stopAnimating()

        }
    }
    
}
