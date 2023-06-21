//
//  RecipeListViewController.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 20/06/23.
//

import UIKit
import FirebaseFirestore

class RecipeListViewController: UIViewController {

    @IBOutlet weak var tableViewRecipeList: UITableView!
    @IBOutlet weak var autocomplete: UITextField!
    
    let identifier = "RecipeListTableViewCell"
    var result: ResultsDecodable!
    var modelList: [Recipe.ViewModel]!
    var modelListFiltered: [Recipe.ViewModel]!
    var filtered: [RecipeDecodable]!
    var features: RecipeListFeaturesProtocol?
    var docRef: DocumentReference! // Firestore
    
    convenience init(features: RecipeListFeaturesProtocol) {
        self.init()
        self.features = features
    }
    
    convenience init(modelList: [Recipe.ViewModel], features: RecipeListFeaturesProtocol) {
        self.init()
        self.modelList = modelList
        self.features = features
    }
    
//    convenience init(result: ResultsDecodable, features: RecipeListFeaturesProtocol) {
//        self.init()
//        self.result = result
//        self.features = features
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.prepareTable()
        self.prepareAutocomplete()
        self.prepareOverall()
        self.request()
    }

    private func prepareTable() {
        self.tableViewRecipeList.delegate = self
        self.tableViewRecipeList.dataSource = self
        self.tableViewRecipeList.register(UINib(nibName: self.identifier, bundle: nil), forCellReuseIdentifier: self.identifier)
    }
    
    private func prepareAutocomplete() {
        self.autocomplete.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private func prepareOverall() {
        self.features?.presentFeatures(delegate: self)
    }
    
    @objc func hola(sender : UIButton) {
        print("HOLA")
    }

    private func request() {
        if let model = self.modelList, !model.isEmpty {
            self.modelListFiltered = self.modelList
            self.tableViewRecipeList.reloadData()
        } else {
            let presenter = RecipeListPresenter(vc: self)
            let interactor = RecipeListInteractor(presenter: presenter)
            interactor.request()
        }
    }
    
    // TODO REMOVE
    func presentRecipeList(resultsDecodable: ResultsDecodable) {
        debugPrint(resultsDecodable)
        self.result = resultsDecodable
        self.filtered = self.result.results!
        self.tableViewRecipeList.reloadData()
    }

    func presentRecipeList(modelList: [Recipe.ViewModel]) {
        self.modelList = modelList
        self.modelListFiltered = self.modelList
        self.tableViewRecipeList.reloadData()
    }

    func presentError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "No se pueden consultar recetas. Intentar mas tarde", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.modelListFiltered = self.modelList
        if textField.text!.count > 0 {
            self.modelListFiltered = self.modelList!.filter { $0.title.localizedCaseInsensitiveContains(textField.text!) }
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
        var recipeVC = RecipeViewController(recipe: self.modelListFiltered[indexPath.row])
        self.navigationController?.pushViewController(recipeVC, animated: true)
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let res = self.self.modelListFiltered else { return 0 }
        return res.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = self.modelListFiltered[indexPath.row]

        let cell = tableViewRecipeList.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! RecipeListTableViewCell
        cell.labelName.text = recipe.title
        return cell

    }
}

protocol RecipeListFeaturesProtocol {
    func presentFeatures(delegate: RecipeListViewController)
}

class RecipeListFeaturesEmpty: RecipeListFeaturesProtocol {
    func presentFeatures(delegate: RecipeListViewController) {
    }
}

class RecipeListFeaturesFavorites: RecipeListFeaturesProtocol {
    var delegate: RecipeListViewController?
    
    func presentFeatures(delegate: RecipeListViewController) {
        self.delegate = delegate
        let button = UIButton(frame: CGRect(x: 20, y: 765, width: 200, height: 60))
        button.setTitle("Favorites", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        self.delegate!.view.addSubview(button)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        Firestore.firestore().collection("Recipes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var modelList: [Recipe.ViewModel] = []
                var recipe: Recipe.ViewModel
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    modelList.append(Recipe.ViewModel(id: document.data().filter { $0.key == "id"}["id"] as! Int,
                                    title: document.data().filter { $0.key == "title"}["title"] as! String,
                                    image: document.data().filter { $0.key == "image"}["image"] as! String as! String,
                                    imageType: document.data().filter { $0.key == "imageType"}["imageType"] as! String))
                }
                let vcFavorites = RecipeListViewController(modelList: modelList, features: RecipeListFeaturesEmpty())
                self.delegate?.navigationController?.pushViewController(vcFavorites, animated: true)
            }
        }
    }
}

