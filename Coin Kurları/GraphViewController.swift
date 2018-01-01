//
//  GraphViewController.swift
//  Coin Kurları
//
//  Created by Emre HAVAN on 23.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GraphViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIWebViewDelegate, UITextFieldDelegate, GADBannerViewDelegate {
    @IBOutlet weak var bannerView: GADBannerView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var graphView: UIWebView!
    
    //MARK: Ugly array :/
    var pickerInputs = ["bitcoin-btc",
                        "ethereum-eth",
                        "bitcoin-cash-bch",
                        "ripple-xrp",
                        "litecoin-ltc",
                        "iota-iot",
                        "cardano-ada",
                        "dash-dash",
                        "nem-xem",
                        "monero-xmr",
                        "bitcoin-gold-btg",
                        "eos-eos",
                        "stellar-xlm",
                        "neo-neo",
                        "qtum-qtum",
                        "ethereum-classic-etc",
                        "verge-xvg",
                        "positron-tron",
                        "lisk-lsk",
                        "bitconnect-bcc",
                        "zcash-zec",
                        "nxt-nxt",
                        "waves-waves",
                        "omisego-omg",
                        "populous-ppt",
                        "bitshares-bts",
                        "hshare-hsr",
                        "tether-usdt",
                        "ardor-ardr",
                        "stratis-strat",
                        "komodo-kmd",
                        "bytecoin-bte",
                        "augur-rep",
                        "dogecoin-doge",
                        "steem-steem",
                        "siacoin-sc",
                        "veritaseum-veri",
                        "monacoin-mona",
                        "ark-ark",
                        "raiblocks-xrb",
                        "decred-dcr",
                        "salt-salt",
                        "status-snt",
                        "electroneum-etn",
                        "digibyte-dgb",
                        "golem-network-tokens",
                        "pivx-pivx",
                        "binance-coin-bnb",
                        "bitcoindark-btcd",
                        "byteball-gbyte",
                        "vechain-ven",
                        "santiment-san",
                        "walton-wtc",
                        "tenx-pay",
                        "power-ledger-powr",
                        "bytom-btm",
                        "maidsafe-coin-maid",
                        "reddcoin-rdd",
                        "basic-attention-token-bat",
                        "qash-qash",
                        "digix-dao-dgd",
                        "factoids-fct",
                        "zcoin-xzc",
                        "vertcoin-vtc",
                        "aeternity-ae",
                        "syscoin-sys",
                        "kyber-network-knc",
                        "0x-zrx",
                        "gas-gas",
                        "gamecredits-game",
                        "bitbay",
                        "ethos-ethos",
                        "funfair-fun",
                        "einsteinium-emc2",
                        "aion-aion",
                        "dragonchain-drgn",
                        "cryptonex-cnx",
                        "civic-cvc",
                        "gxshares-gxs",
                        "decentraland-mana",
                        "edgeless-edg",
                        "iconomi-icn",
                        "rise-rise",
                        "nexus-nxs",
                        "gnosis-gno",
                        "monaco-mco",
                        "raiden-network-token-rdn",
                        "request-network-req",
                        "ubiqoin-ubiq",
                        "bancor-bnt",
                        "blocknet-block",
                        "metalcoin-metal",
                        "dent-dent",
                        "time-new-bank-tnb",
                        "sonm-snm",
                        "streamr-datacoin-data",
                        "substratum-sub",
                        "navcoin-nav",
                        "centra-ctr",
                        "burstcoin-burst", ]
    var picker = UIPickerView()

    @IBOutlet weak var currencyTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.delegate = self
        picker.delegate = self
        picker.dataSource = self
        currencyTextField.inputView = picker
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        openingGraph()
//        graphView.isUserInteractionEnabled = false
        
        let request = GADRequest()
        bannerView.adUnitID = "ca-app-pub-9102512487367812/3495048221"
        bannerView.rootViewController = self
        bannerView.load(request)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(GraphViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    // Alphabet thing.
    }
    @IBAction func showGraphTapped(_ sender: Any) {
        
        guard currencyTextField.text == "" else {
            
            let url = URL(string: "https://www.yapayzekam.com/grafik.php?link=\(currencyTextField.text!)")
            let myRequest = URLRequest(url: url!)
            graphView.loadRequest(myRequest)
            currencyTextField.resignFirstResponder()
            return
        }
        showAlert(title: "Coin Seçiniz", message: "Lütfen bir coin seçiniz.")
        return
    }
    
    // Web View Thing. - Web View Ayarlamaları.
    func openingGraph() {
        
        let url = URL(string: "https://yapayzekam.com/grafik.php?link=bitcoin-btc")
        let myRequest = URLRequest(url: url!)
        graphView.loadRequest(myRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
//        graphView.isUserInteractionEnabled = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
        
//        graphView.scrollView.setContentOffset(CGPoint(x: 0, y: 280), animated: true)
//        graphView.isUserInteractionEnabled = true
//        graphView.scrollView.isScrollEnabled = false
        
    }
    
    
    // Picker View Thing - Picker View Ayarlamaları.
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
    
    
    //keyboard thing - klavye ayarlamaları
    @objc func dismissKeyboard(tap: UITapGestureRecognizer) {
        currencyTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currencyTextField.resignFirstResponder()
        return true
    }
    
}
