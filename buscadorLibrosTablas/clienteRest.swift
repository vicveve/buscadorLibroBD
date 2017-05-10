//
//  clienteRest.swift
//  buscadorLibrosTablas
//
//  Created by Victor Ernesto Velasco Esquivel on 24/04/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import Foundation
import SystemConfiguration

class RestCliente {
    
    init() {
        
    }
    
    
    func buscarLibroFormateado(codigo : String) -> LibroClass {
        let response : LibroClass = LibroClass()
        
        
        let json = sincrono(code: codigo)
        let jsonSring = sincronoString(code: codigo)
        if (jsonSring.characters.count<3){
            response.AgregaAutores(autor: "Sin información")
            response.AgregaTitulo(titulo: "Sin información")
            return response
        }
        let Niv1 = json as! NSDictionary
        let Niv2 = Niv1["ISBN:" + codigo] as! NSDictionary
        
        let NivTitulo = Niv2["title"] as! NSString
        response.AgregaTitulo(titulo: NivTitulo as String)
        let NivAutores = Niv2["authors"] as! NSArray
        
        for autor in NivAutores{
            let itemLista = autor as! NSDictionary
            //let url = itemLista["url"] as! NSString
            let autor = itemLista["name"] as! NSString
            response.AgregaAutores(autor: autor as String)
        }
        
        //let llaves = Niv2.allValues
        let llavesCover = Niv2.value(forKey: "cover")
        
        if (llavesCover != nil)
        {
            
            let NivPortada = Niv2["cover"] as! NSDictionary
            let NivPSmall = NivPortada["small"] as! NSString
            let NivPMedium = NivPortada["medium"] as! NSString
            let NivPLarge = NivPortada["large"] as! NSString
            if(NivPSmall as String != "")
            {
                response.AgregaPortadaList(portada: NivPSmall as String)
            }
            if(NivPMedium as String != "")
            {
                response.AgregaPortadaList(portada: NivPMedium as String)
            }
            if(NivPLarge as String != "")
            {
                response.AgregaPortadaList(portada: NivPLarge as String)
            }
            
        }
        
        response.Succes = true
        response.Isbn = codigo
        return response
    }
    
    func sincronoString(code : String)  -> String {
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + code
        
        
        
        //978-84-376-0494-7"
        let url = NSURL(string: urls)
        let datos :  NSData? = NSData (contentsOf : url! as URL)
        let texto = NSString(data: datos as! Data, encoding: String.Encoding.utf8.rawValue )
        
        return texto as! String
        
    }
    
    func sincrono(code : String)  -> Any {
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + code
        
        
        
        //978-84-376-0494-7"
        let url = NSURL(string: urls)
        let datos :  NSData? = NSData (contentsOf : url! as URL)
        var jsonResponse : Any = ""
        
        
        do{
            jsonResponse = try JSONSerialization.jsonObject(with: datos! as Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            
        }
        catch _ {
            
        }
        
        return jsonResponse
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
}

class LibroClass{
    
    var Autores : String
    var Portada : String
    var Titulo : String
    var autoresList : [String] = []
    var Succes : Bool = false
    var ErrorMessage : String
    var portadaList : [String] = []
    var Isbn : String
    
    init() {
        Autores = ""
        Portada = ""
        Titulo = ""
        Succes = false
        ErrorMessage = ""
        Isbn = ""
    }
    
    func AgregaIsbn(isbn : String) {
        self.Isbn = isbn
    }
    
    func AgregaTitulo(titulo : String) {
        self.Titulo = titulo
    }
    
    func AgregaPortada(portada : String){
        self.Portada = portada
    }
    
    func AgregaAutores(autor : String) {
        autoresList.append(autor)
    }
    
    func AgregaPortadaList(portada : String){
        portadaList.append(portada)
    }
    
    func RecuperaTitulo() -> String {
        return Titulo
    }
    
    func RecuperaIsbn() -> String {
        return Isbn
    }

    
    func RecuperaAutores() -> String {
        
        for ing in autoresList{
            Autores.append("-\(ing)\n")
        }
        
        return Autores
    }
    
    func RecuperaPortada() -> String {
        
        for ing in portadaList{
            Portada.append("-\(ing)\n")
        }
        
        return Portada
    }
    
    
}

class LibrosSesion : NSObject, NSCoding{
    var listaLibros : Array<LibroClass> = Array<LibroClass>()
    
    override init() {
        
    }
    
    func AddLibroSesion(item : LibroClass) {
        
        let bAgrega = Existe(item: item)
        
        if (!bAgrega){
            listaLibros.append(item)
        }
        
    }
    
    
    func Existe(item : LibroClass) -> Bool {
        
        var bExiste : Bool = false
        
        for a in listaLibros{
            
            if a.RecuperaTitulo() == item.RecuperaTitulo(){
                bExiste = true
            }
            
        }
        
        return bExiste
        
    }
    
    required init(coder decoder: NSCoder) {
        self.listaLibros = decoder.decodeInteger(forKey: "libros") as? Array<LibroClass> ?? Array<LibroClass>()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(listaLibros, forKey: "libros")
        
    }
    
}
