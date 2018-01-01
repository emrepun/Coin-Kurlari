//
//  ViewController.swift
//  Coin Kurları
//
//  Created by Emre HAVAN on 21.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMobileAds

class CoinViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GADBannerViewDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var coins = [CoinToGo]()
    var currentCoins = [CoinToGo]()
    
    var tlDollarWorth = ""
    var tlEuroWorth = ""
    var tlCoinWorth = ""
    let connectionError = "İnternete bağlı olduğunuzdan emin olunuz. Eğer internet bağlantınız olmasına rağmen sorun yaşıyorsanız, lütfen destekle iletişime geçiniz."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(getRates), for: .valueChanged)
        // Do any additional setup after loading the view, typically from a nib.
        getRates()
        
        let request = GADRequest()
        bannerView.adUnitID = "ca-app-pub-9102512487367812/3495048221"
        bannerView.rootViewController = self
        bannerView.load(request)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CoinViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    
    //MARK: Retrieve coin infos and append them as a coin to a coin array. Api bağlantısı, coin bilgileri ve kur bilgilerini çekiyor, ve sonra oluşturduğumuz bu coinleri array e atıyoruz.
    @objc func getRates() {
        let url = "https://api.coinmarketcap.com/v1/ticker/"
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                for i in 0..<100 {
                    
                    let json = JSON(value)
                    let myJson = json[i]
                    let myCoin = CoinToGo(name: myJson["name"].stringValue, price_usd: myJson["price_usd"].stringValue, percent_change_24h: myJson["percent_change_24h"].stringValue, id: myJson["id"].stringValue)
                    self.coins.append(myCoin)
                }
                self.setUpSearchBar()
                self.currentCoins = self.coins
                self.getDollarRate()

            case .failure( _):
                self.showAlert(title: "Bağlantı Sorunu", message: self.connectionError)
            }
        }
    }
    
    //MARK: Retrieve dollar selling price for turkish lira.
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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                }
            case .failure( _):
                self.showAlert(title: "Bağlantı Sorunu", message: self.connectionError)
            }
        }
    }
    
    @objc func dismissKeyboard(tap: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: TableView Thing.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CoinCell else { return UITableViewCell() }
        cell.dollarLabel.text = String(Double(currentCoins[indexPath.row].price_usd)!.yuvarla(basamak: 3))
        cell.coinLabel.text = currentCoins[indexPath.row].name
        cell.percentageLabel.text = "% \(currentCoins[indexPath.row].percent_change_24h)"
        if currentCoins[indexPath.row].percent_change_24h.doubleValue > 0 {
            cell.percentageLabel.textColor = .green
        } else {
            cell.percentageLabel.textColor = .red
        }
        cell.tlLabel.text = String((Double(currentCoins[indexPath.row].price_usd)! * Double(self.tlDollarWorth)!).yuvarla(basamak: 3))
        cell.euroLabel.text = String(((Double(currentCoins[indexPath.row].price_usd)! * Double(self.tlDollarWorth)!) / Double(self.tlEuroWorth)!).yuvarla(basamak: 3))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCoins.count
    }
    
    //MARK: Searchbar thing.
    func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBarShouldReturn(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            currentCoins = coins
            tableView.reloadData()
            return
        }
        
        currentCoins = coins.filter({ coin -> Bool in
            coin.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

    
}









