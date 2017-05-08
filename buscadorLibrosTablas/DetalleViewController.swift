//
//  DetalleViewController.swift
//  buscadorLibrosTablas
//
//  Created by Victor Ernesto Velasco Esquivel on 24/04/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController {

    var itemDetalle : LibroClass = LibroClass()
    @IBOutlet weak var lblPortadas: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    
    @IBOutlet weak var txtautores: UITextView!
    
    @IBOutlet weak var imgPortada: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MuestraInformacion(item: itemDetalle)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func MuestraInformacion(item : LibroClass){
        
        lblTitulo.text = item.RecuperaTitulo()
        txtautores.text = item.RecuperaAutores()
        if(item.portadaList.count > 0){
            imgPortada.isHidden = false
            let urlImageDown = NSURL(string: item.portadaList[0] )
            downloadImage(url: urlImageDown as! URL)
            
            lblPortadas.isHidden = true
        }
        else{
            lblPortadas.isHidden = false
            imgPortada.isHidden = true
        }
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.imgPortada.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
