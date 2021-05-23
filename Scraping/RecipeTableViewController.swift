//
//  ViewController.swift
//  Scraping
//
//  Created on 2021/05/22.
//

import UIKit
import Alamofire
import Kanna

class RecipeTableViewController: UITableViewController {
    var cooking = [Recipe]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRecipe()
    }
    func getRecipe() {
        AF.request("https://cookpad.com/recipe/5593539").responseString { response in
            switch response.result {
            case let .success(value):
                if let doc = try? HTML(html: value, encoding: .utf8) {
                    
                    var ingredients = [String]()
                    for link in doc.xpath("//span[@class='name']") {
                        ingredients.append(link.text ?? "")
                    }
                    
                    var amounts = [String]()
                    for link in doc.xpath("//div[@class='ingredient_quantity amount']") {
                        amounts.append(link.text ?? "")
                    }
                    
                    for (index, value) in ingredients.enumerated() {
                        let recipe = Recipe()
                        recipe.ingredient = value
                        recipe.amount = amounts[index]
                        self.cooking.append(recipe)
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
        return self.cooking.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let recipe = self.cooking[indexPath.row]
        cell.textLabel?.text = recipe.ingredient
        cell.detailTextLabel?.text = recipe.amount

        return cell
    }
}
