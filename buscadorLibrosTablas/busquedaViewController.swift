//
//  busquedaViewController.swift
//  buscadorLibrosTablas
//
//  Created by Victor Ernesto Velasco Esquivel on 24/04/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit
import CoreData

class busquedaViewController: UIViewController {
    
    
    var contexto : NSManagedObjectContext? = nil

    
    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblAutores: UITextView!
    @IBOutlet weak var lblPortada: UILabel!
    
    @IBOutlet weak var portada: UIImageView!
    
    @IBOutlet weak var lblIsbn: UILabel!
    
    var Libros : Array<LibroClass> = Array<LibroClass>()
    var LibroItem : LibroClass = LibroClass()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var buscarLibro: UIButton!
    
    @IBAction func Buscar(_ sender: Any) {
        
        var codigo = txtISBN.text
        if(codigo?.characters.count == 0){
            alerta(mensaje: "El SBN no puede estar vacio", titulo: "Alerta")
            return
        }
        
        let libroEntidad = NSEntityDescription.entity(forEntityName: "Libro", in: self.contexto!)
        
        let peticion = libroEntidad?.managedObjectModel.fetchRequestFromTemplate(withName: "pcLibro", substitutionVariables: ["sbn": txtISBN.text])
        
        do{
            let libroconsulta = try self.contexto?.fetch(peticion!) as! [NSObject]
            
            if (libroconsulta.count > 0){
                alerta(mensaje: "El libro ya se agrego con anterioridad", titulo: "Información")
                return
            }
        }catch{
            
        }
        
        
        let libro = RestCliente();
        LibroItem = libro.buscarLibroFormateado(codigo: txtISBN.text!)
        
        
        
        if(LibroItem.Succes){
            
            //Libros.append(LibroItem)
            let libroEntidadNueva = NSEntityDescription.insertNewObject(forEntityName: "Libro", into: self.contexto!)
            
            libroEntidadNueva.setValue(txtISBN.text!, forKey: "sbn")
            
            let datosTitulo = creaTituloEntidad(tituloLibro: LibroItem.RecuperaTitulo())
            
            libroEntidadNueva.setValue(datosTitulo, forKey: "libroTitulo")
            
            //Titulo
            
            //Autores
            
            libroEntidadNueva.setValue(creaAutoresEntidad(autoreslist: LibroItem.autoresList), forKey: "libroAutor")
            
            //portadas
            libroEntidadNueva.setValue(creaportadaEntidad(portadalist: LibroItem.portadaList), forKey: "libroPortada")
            
            do{
                try self.contexto?.save()
            }catch{
                
            }
            
            txtISBN.text = ""
            alerta(mensaje: "Se agrego el libro correctamente", titulo: "Alerta")
            
            lblIsbn.text = codigo
            lblTitulo.text = LibroItem.RecuperaTitulo()
            lblPortada.text = LibroItem.RecuperaPortada()
            lblAutores.text = LibroItem.RecuperaAutores()
            if(LibroItem.portadaList.count > 0){
                portada.isHidden = false
                let urlImageDown = NSURL(string: LibroItem.portadaList[0] )
                downloadImage(url: urlImageDown as! URL)
                
                lblPortada.isHidden = true
            }
            else{
                lblPortada.isHidden = false
                portada.isHidden = true
            }

            
        }
        else{
            alerta(mensaje: "No se encontro el libro solicitado", titulo: "Alerta")
            return
        }
        
    }
    
    @IBAction func BuscarNuevoLibro(_ sender: Any) {
        
       
        
        
        
        
        let libro = RestCliente();
        LibroItem = libro.buscarLibroFormateado(codigo: txtISBN.text!)
        
      
        
        if(LibroItem.Succes){
           
            
            var add = LibrosViewController().ActualizaLista(libro: LibroItem)
            alerta(mensaje: "Se agrego el libro correctamente", titulo: "Alerta")

        }
        else{
            alerta(mensaje: "No se encontro el libro solicitado", titulo: "Alerta")
        }
        
    }
    /*
    func crearTituloLibro(titulo : String) -> Set<NSObject>{
        var entidad  = Set<NSObject>()
        
        let tituloEntidad = NSEntityDescription.insertNewObject(forEntityName: "titulo", into: self.contexto!)
        
        tituloEntidad.setValue(titulo, forKey: "titulo")
        
        entidad.insert(tituloEntidad)
        
        
        return entidad
    }
    
    func crearAutoresLibros(autores : [String]) -> Set<NSObject>{
        var entidad  = Set<NSObject>()
        
        
        for autor in autores
        {
            let autorEntidad = NSEntityDescription.insertNewObject(forEntityName: "Titulo", into: self.contexto!)
            
            autorEntidad.setValue(autor, forKey: "titulo")
            
            entidad.insert(autorEntidad)

        }
        
        
        return entidad
    }
    
    func crearPortadaLibros(portadas : [String]) -> Set<NSObject>{
        var entidad  = Set<NSObject>()
        
        
        for portada in portadas
        {
            let portadaEntidad = NSEntityDescription.insertNewObject(forEntityName: "Portada", into: self.contexto!)
            
            portadaEntidad.setValue(portada, forKey: "portada")
            
            entidad.insert(portadaEntidad)
            
        }
        
        
        return entidad
    }*/


    
    func alerta(mensaje : String, titulo: String){
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }*/
    
    func save(){
       // let sigVista=segue.destination as! LibrosViewController
        
        
       
        //sigVista.Libros = Libros
    }
    
    func creaTituloEntidad(tituloLibro : String) -> Set<NSObject>{
        var titulo = Set<NSObject>()
        let tituloEntidadNueva = NSEntityDescription.insertNewObject(forEntityName: "Titulo", into: self.contexto!)

        tituloEntidadNueva.setValue(tituloLibro, forKey: "titulo")
        titulo.insert(tituloEntidadNueva)
        return titulo
        
    }
    
    func creaAutoresEntidad(autoreslist : Array<String>) -> Set<NSObject>{
        var autores = Set<NSObject>()
        
        for itemautor in autoreslist{
            let autorEntidadNueva = NSEntityDescription.insertNewObject(forEntityName: "Autores", into: self.contexto!)
            autorEntidadNueva.setValue(itemautor, forKey: "nombreAutor")
            autores.insert(autorEntidadNueva)
        }
       
        return autores
        
        
        
    }
    
    func creaportadaEntidad(portadalist : Array<String>) -> Set<NSObject>{
        var portadas = Set<NSObject>()
        
        for itemautor in portadalist{
            let autorEntidadNueva = NSEntityDescription.insertNewObject(forEntityName: "Portadas", into: self.contexto!)
            autorEntidadNueva.setValue(itemautor, forKey: "portada")
            portadas.insert(autorEntidadNueva)
        }
        
        return portadas
        
        
        

        
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.portada.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }



}
