//
//  RecipeViewController.swift
//  SpoonacularAmaris
//
//  Created by Juan Manuel Moreno on 20/06/23.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonAddToFavorites: UIButton!
    
    var recipe: Recipe.ViewModel!
    
    convenience init(recipe: Recipe.ViewModel) {
        self.init()
        self.recipe = recipe
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.labelTitle.text = recipe.title
        self.imageRecipe.setImageWithURL(URL(string: recipe.image)!)
    }

    @IBAction func actionAddToFavorites(_ sender: Any) {
        RecipeInteractor().addToFavorites(recipe: Recipe.Request(id: recipe.id,
                                                                 title: recipe.title,
                                                                 image: recipe.image,
                                                                 imageType: recipe.imageType))
        self.navigationController?.popViewController(animated: true)
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
