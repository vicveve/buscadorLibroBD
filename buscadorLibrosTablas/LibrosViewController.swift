//
//  LibrosViewController.swift
//  buscadorLibrosTablas
//
//  Created by Victor Ernesto Velasco Esquivel on 24/04/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit
import CoreData

class LibrosViewController: UITableViewController {

     var Libros : Array<LibroClass> = Array<LibroClass>()
    var contexto : NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var item = RestCliente()
        //var itemUno = item.buscarLibroFormateado(codigo: "978-4-08-880327-2")
        
       // Libros.append(itemUno)
        
        self.title = "Libros"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.plain, target: self, action: "AgregarLibro")
        
        
        //self.contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let libroEntidad = NSEntityDescription.entity(forEntityName:  "Libro",in: self.contexto!)
        
       
        let peticion = libroEntidad?.managedObjectModel.fetchRequestTemplate(forName: "pcLibrosList")
        //print(peticion)
       /* guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let FETCHREQUEST   = NSFetchRequest<NSManagedObject>(entityName: "pcLibrosList")*/
        do{
            if (peticion != nil)
            {
                //let librosEntidad = try self.contexto?.fetch(peticion!)
                //let librosEntidad = try self.contexto?.fetch(peticion!)
                let librosEntidad = try self.contexto?.fetch(peticion!) as! [NSObject]
                for libroitem in librosEntidad {

                    var LibroBD : LibroClass = LibroClass()
                    let ISBN = libroitem.value(forKey: "sbn") as! String
                    
                   let Titulos = libroitem.value(forKey: "libroTitulo") as! Set<NSObject>
                    var TitulosLista = [String]()
                    for x in Titulos{
                        let descTitulo = x.value(forKey: "titulo") as! String
                        TitulosLista.append(descTitulo)
                    }
                    
                    LibroBD.AgregaTitulo(titulo: TitulosLista[0])
                    
                    let Autores = libroitem.value(forKey: "libroAutor") as! Set<NSObject>
                    
                    let Portadas = libroitem.value(forKey: "libroPortada") as! Set<NSObject>
                    
                    var AutoresLista = [String]()
                    for x in Autores{
                        let descAutor = x.value(forKey: "nombreAutor") as! String
                        AutoresLista.append(descAutor)
                    }
                    LibroBD.autoresList = AutoresLista
                    
                    var PortadasLista = [String]()
                    for x in Portadas{
                        let url = x.value(forKey: "portada") as! String
                        PortadasLista.append(url)
                    }
                    LibroBD.portadaList = PortadasLista

                    Libros.append(LibroBD)
                 }
                

            }
        }
        catch{
            
        }
        
        
    }
    
    
    func AgregarLibro() {
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "agregarLibros") as! busquedaViewController
        resultViewController.Libros=self.Libros
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return Libros.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = Libros[indexPath.row].RecuperaTitulo();

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cc = segue.destination as! DetalleViewController
        
        let item = self.tableView.indexPathForSelectedRow
        
        cc.itemDetalle = self.Libros[(item?.row)!]
        
    }
    
    
    func ActualizaLista(libro : LibroClass) {
        
        Libros.append(libro)
        
    }
 

}
