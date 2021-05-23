//
//  ViewController.swift
//  Scraping
//
//  Created by 田村圭佑 on 2021/05/22.
//

import UIKit
//HTTP通信してくれるやつ
import Alamofire
//スクレイピングしてくれるやつ
import Kanna

class RecipeViewController: UITableViewController {
    var beefbowl = [Gyudon]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getGyudonPrice()
    }
    func getGyudonPrice() {
    //スクレイピング対象のサイトを指定
        AF.request("https://cookpad.com/recipe/5593539").responseString { response in
            switch response.result {
            case let .success(value):
                if let doc = try? HTML(html: value, encoding: .utf8) {
                    
                    // 牛丼のサイズをXpathで指定
                    var sizes = [String]()
                    for link in doc.xpath("//span[@class='name']") {
                        sizes.append(link.text ?? "")
                    }
                    
                    //牛丼の値段をXpathで指定
                    var prices = [String]()
                    for link in doc.xpath("//div[@class='ingredient_quantity amount']") {
                        prices.append(link.text ?? "")
                    }
                    
                    //牛丼のサイズ分だけループ
                    for (index, value) in sizes.enumerated() {
                        let gyudon = Gyudon()
                        gyudon.size = value
                        gyudon.price = prices[index]
                        self.beefbowl.append(gyudon)
                    }
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beefbowl.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let gyudon = self.beefbowl[indexPath.row]
        cell.textLabel?.text = gyudon.size
        cell.detailTextLabel?.text = gyudon.price

        return cell
    }
}
