//
//  RecipeListViewController.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 20/06/23.
//

import UIKit

class RecipeListViewController: UIViewController {

    // MARK: Character
    @IBOutlet weak var tableViewRecipeList: UITableView!
    @IBOutlet weak var autocomplete: UITextField!
    
    let identifier = "RecipeListTableViewCell"
    var result: ResultsDecodable!
    var modelList: [Recipe.ViewModel]!
    var modelListFiltered: [Recipe.ViewModel]!
    var filtered: [RecipeDecodable]!
    var features: RecipeListFeaturesProtocol?
    var presenter: RecipeListPresenter!
    var interactor: RecipeListInteractor!
    var spinner = SpinnerViewController()

    
    // MARK: Init
    convenience init(features: RecipeListFeaturesProtocol) {
        self.init()
        self.features = features
    }
    
    convenience init(modelList: [Recipe.ViewModel], features: RecipeListFeaturesProtocol) {
        self.init()
        self.modelList = modelList
        self.features = features
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.prepareTable()
        self.prepareAutocomplete()
        self.prepareOverall()
        self.presenter = RecipeListPresenter(vc: self)
        self.interactor = RecipeListInteractor(presenter: presenter)
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
    
    // MARK: Request recipe list
    private func request() {
        if let model = self.modelList, !model.isEmpty {
            self.modelListFiltered = self.modelList
            self.tableViewRecipeList.reloadData()
        } else if self.features!.haveToRequest() {
            self.createSpinnerView()
            self.interactor.requestRecipeList()
        }
    }
    
    // MARK: Present recipe list
    func presentRecipeList(modelList: [Recipe.ViewModel]) {
        self.removeSpinner()
        self.modelList = modelList
        self.modelListFiltered = self.modelList
        self.tableViewRecipeList.reloadData()
    }

    func presentRecipeListFavorites(modelList: [Recipe.ViewModel]) {
        self.removeSpinner()
        let router = RecipeListRouter().routeToFavorites(from: self, to: RecipeListViewController(modelList: modelList, features: RecipeListFeaturesRequestNone()))
    }
    
    func presentError(error: Error) {
        self.removeSpinner()
        let alert = UIAlertController(title: "Error", message: "No se pueden consultar recetas. Intentar mas tarde", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: UI
    func createSpinnerView() {
        addChild(self.spinner)
        self.spinner.view.frame = view.frame
        view.addSubview(self.spinner.view)
        self.spinner.didMove(toParent: self)
    }
    
    func removeSpinner() {
        self.spinner.willMove(toParent: nil)
        self.spinner.view.removeFromSuperview()
        self.spinner.removeFromParent()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        self.modelListFiltered = self.modelList
        if textField.text!.count > 0 {
            self.modelListFiltered = self.modelList!.filter { $0.title.localizedCaseInsensitiveContains(textField.text!) }
        }
        self.tableViewRecipeList.reloadData()
    }
}

// MARK: UITableView
extension RecipeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let router = RecipeListRouter().routeToRecipe(from: self, to: RecipeViewController(recipe: self.modelListFiltered[indexPath.row]))
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let res = self.self.modelListFiltered else { return 0 }
        return res.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = self.modelListFiltered[indexPath.row]

        let cell = tableViewRecipeList.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! RecipeListTableViewCell
        cell.labelName.text = recipe.title
        cell.imageRecipe.load(url: URL(string: recipe.image)!)
        return cell

    }
}

// MARK: Features for View Controller
protocol RecipeListFeaturesProtocol {
    func presentFeatures(delegate: RecipeListViewController)
    func haveToRequest() -> Bool
}

class RecipeListFeaturesRequestNone: RecipeListFeaturesProtocol {
    func presentFeatures(delegate: RecipeListViewController) {}
    
    func haveToRequest() -> Bool {
        return false
    }
}

class RecipeListFeaturesRequestListAndFavorites: RecipeListFeaturesProtocol {
    var delegate: RecipeListViewController?
    
    func presentFeatures(delegate: RecipeListViewController) {
        self.delegate = delegate
        var image = UIImage(named: "heart")
        image = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        let btnFavorites = UIButton(frame: CGRect(x: 20, y: 660, width: 42, height: 56))
        btnFavorites.setImage(image, for: .normal)
        btnFavorites.invalidateIntrinsicContentSize()
        btnFavorites.sizeToFit()
        btnFavorites.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btnFavorites.invalidateIntrinsicContentSize()
        btnFavorites.sizeToFit()
        btnFavorites.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        self.delegate!.view.addSubview(btnFavorites)
    }
    
    func haveToRequest() -> Bool {
        return true
    }
    
    @objc func buttonTapped(sender: UIButton) {
        self.delegate?.createSpinnerView()
        self.delegate?.interactor.requestRecipeListFavorites()
    }
}

// MARK: Extension for UI
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
