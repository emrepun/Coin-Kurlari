//
//  TweetViewController.swift
//  Coin Kurları
//
//  Created by Emre HAVAN on 23.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//

import UIKit
import GoogleMobileAds


class TweetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIWebViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var tweetView: UIWebView!
    
    //MARK: Ugly array :/
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
    var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        tweetView.delegate = self
        currencyTextField.inputView = picker
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        openingTweet()
        
        let request = GADRequest()
        bannerView.adUnitID = "ca-app-pub-9102512487367812/3495048221"
        bannerView.rootViewController = self
        bannerView.load(request)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(GraphViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    @IBAction func showTweetsTapped(_ sender: Any) {
        
        guard currencyTextField.text == "" else {
            
            let url = URL(string: "https://twitter.com/search?q=%23\(currencyTextField.text!)&src=typd")
            let myRequest = URLRequest(url: url!)
            tweetView.loadRequest(myRequest)
            currencyTextField.resignFirstResponder()
            return
        }
        showAlert(title: "Coin Seçiniz", message: "Lütfen bir coin seçiniz.")
        return
    }
    
    // Picker View Thing
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
    
    //keyboard thing.
    @objc func dismissKeyboard(tap: UITapGestureRecognizer) {
        currencyTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currencyTextField.resignFirstResponder()
        return true
    }
    
    // Web View Thing.
    
    func openingTweet() {
        
        let url = URL(string: "https://twitter.com/search?q=%23bitcoin&src=typd")
        let myRequest = URLRequest(url: url!)
        tweetView.loadRequest(myRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
}







