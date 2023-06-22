# SpoonacularAmaris
Solución app Spoonacular proceso de selección Amaris.
Por Juan Manuel Moreno Beltran {iOS native}

# Arquitectura
El diseño y construcción del proyecto siguen los lineamientos de los principios Clean Architeture
[https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

Para esto se eligió con patrón de arquitectura VIPER y construcción siguiendo los principios SOLID
[https://medium.com/build-and-run/clean-architecture-en-ios-viper-893c8c3a75a4](https://medium.com/build-and-run/clean-architecture-en-ios-viper-893c8c3a75a4)

# Esquema de arquitectura
Principio Clean Architecture

Entity
Recipe | RecipeList
)))

Business Use Case
GetRecipeListUseCase | GetRecipeListFavoritesUseCase | AddRecipeToFavoritesUseCase
)))

Interface
RecipeListViewController | RecipeListInteractor | RecipeListPresenter | RecipeListRouter
)))

Frameworks
APICliente | Cloud Firestore

# Issues y Soluciones

## Cómo crear un proyecto en Storyboard con vistas programadas eligiendo una vista como pieza de entrada a la app
Código SceneDelegate:
```  
guard let aScene = (scene as? UIWindowScene) else { return }
window = UIWindow(windowScene: aScene)
let nvc = UINavigationController(rootViewController: RecipeListViewController(features: RecipeListFeaturesRequestListAndFavorites()))
window?.rootViewController = nvc
window?.makeKeyAndVisible()
```
Esta solución permite también hacer una navegación push pop no modal sin segues manteniendo el esquema Storyboard

## Cómo autocompletar
Se agrega el código del selector siguiente:
```  
@objc func textFieldDidChange(_ textField: UITextField) {
	self.modelListFiltered = self.modelList
	if textField.text!.count > 0 {
		self.modelListFiltered = self.modelList!.filter { $0.title.localizedCaseInsensitiveContains(textField.text!) }
		}
	self.tableViewRecipeList.reloadData()
}
```
Se agrega al campo de texto con el código siguiente
```  
self.autocomplete.addTarget(self,action: #selector(textFieldDidChange(_:)), for: .editingChanged)
```
## Cómo gestionar favoritos
Para ver favoritos se ha extensión de RecipeListViewController mostrando No. De favoritos con el caso de uso Consultar Favoritos (GetRecipeListFavoritesUseCase) siguiendo el principio SOLID O (Abierto a extensión

Para agregar favoritos se usa el caso de uso Agregar Favoritos (AddRecipeToFavoritesUseCase)

## Cómo crear Unit Testing
Se ha creado la pieza RecipeListTests que contiene los casos de prueba de consumo de servicio de consultar recetas siguiendo proceso iterativo Test Driven Development

## Cómo se siguieron principios SOLID
S (Responsabilidad unica casos de uso consultar recetas, consultar favoritos, agregar favoritos

O (Abierto a extensión La clase RecipeListFeaturesProtocol gestiona características adicionales de interacción de RecipelistViewController en lugar de modificarlo

L (Liskov RecipelistViewController utiliza las características RecipeListFeaturesProtocol sin tener en cuenta qué implementación particular utiliza

I (Interfaces

D (Inyección de dependencias RecipeList*** y sus constructores o inicializadores reciben como parámetros sus objetos requeridos manteniendo el patrón VIPER

## Cómo se persisten datos
Se ha hecho uso de Cloud Firestore la nueva  solución de Google Cloud Platform Firebase. Mediante la impartación de las librerías y agregando el proyecto a Firebase, a través de la dinámica de gestión de datos en forma de colecciones y documentos se almacenan objetos de recetas favoritas
[https://firebase.google.com/docs/firestore?hl=es-419](https://firebase.google.com/docs/firestore?hl=es-419)

Agregar usuarios y permisos de acceso al proyecto SpoonacualrAmaris a petición del usuario

## Cómo mostrar imágenes de servidor web
Mediante una extensión de la clase UIImageView en forma asíncrona se importan los contenidos de imágenes como objetos data importándolos a la app como objetos UIImage
```  
func setImageWithURL(_ url: URL) {
	if let download = download {
		if download.url == url {
			return
		}
		download.dataTask.cancel()
	}
	if let image = UIImageView.imageCache.object(forKey: url as NSURL) {
		self.image = image
		return
	}
	image = nil
	let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
		guard let self = self else { return }
		if let error = error, case URLError.cancelled = error {
			if case URLError.cancelled = error {
				return
			}
			self.setImage(nil, error: error, url: url)
			return
		}
		guard let data = data else {
			self.setImage(nil, error: ImageError.missingData, url: url)
			return
		}
		guard let image = UIImage(data: data) else {
			self.setImage(nil, error: ImageError.dataNotImage, url: url)
			return
		}
		self.setImage(image, error: nil, url: url)
	}
	download = ImageDownload(dataTask: task, url: url)
	task.resume()
}
```  
# TODO

## Diseño por interfaces
Diseñar y construir las piezas de acuerdo a arquitectura VIPER mediante protocolos

## Splash Delay
Hallar la forma de demorar el mostrar contenido después del splash.

Este código demora la ejecución de la app el tiempo requerido; sin embargo implica demorar la ejecución de más piezas, opción que no da un performance de calidad a la app

```
Thread.sleep(forTimeInterval: 3.0)
```
Este código demora la pieza SceneDelegate; sin embargo funciona en versiones anteriores a iOS 13. En adelante muestra una app oscura durante la demora.

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            // your code here
            guard let aScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(windowScene: aScene)
            let navigator = UINavigationController(rootViewController: RecipeListViewController(features: RecipeListFeaturesRequestListAndFavorites()))
            window?.rootViewController = navigator
            window?.makeKeyAndVisible()
        }

## Redundancias en favoritosa
Validar que al agregar a favoritos no queden recetas repetidas
