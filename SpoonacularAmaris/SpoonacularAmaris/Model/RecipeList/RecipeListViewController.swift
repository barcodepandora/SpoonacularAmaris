//
//  RecipeListViewController.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 20/06/23.
//

import UIKit

class RecipeListViewController: UIViewController {

    @IBOutlet weak var tableViewRecipeList: UITableView!
    @IBOutlet weak var autocomplete: UITextField!
    
    let identifier = "RecipeListTableViewCell"
    var result: ResultsDecodable!
    var filtered: [RecipeDecodable]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableViewRecipeList.delegate = self
        self.tableViewRecipeList.dataSource = self
        self.tableViewRecipeList.register(UINib(nibName: self.identifier, bundle: nil), forCellReuseIdentifier: self.identifier)
        
        self.autocomplete.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.request()
    }

    private func request() {
        let foo = Foo(vc: self)
        foo.request()
    }
    
    func presentRecipeList(resultsDecodable: ResultsDecodable) {
        debugPrint(resultsDecodable)
        self.result = resultsDecodable
        self.filtered = self.result.results!
        self.tableViewRecipeList.reloadData()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        self.filtered = self.result.results!
        if textField.text!.count > 0 {
            self.filtered = self.result.results!.filter { $0.title!.localizedCaseInsensitiveContains(textField.text!) }
        }
        self.tableViewRecipeList.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecipeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var recipeVC = RecipeViewController(recipe: filtered[indexPath.row])
        self.present(recipeVC, animated: true)
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let res = self.filtered else { return 0 }
        return res.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = self.filtered[indexPath.row]

        let cell = tableViewRecipeList.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! RecipeListTableViewCell
        cell.labelName.text = recipe.title
        return cell

    }
}
