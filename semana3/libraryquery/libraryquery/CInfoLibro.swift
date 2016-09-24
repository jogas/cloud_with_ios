//
//  CInfoLibro.swift
//  libraryquery
//
//  Created by José Manuel Gaytán on 17/09/16.
//  Copyright © 2016 José Manuel Gaytán. All rights reserved.
//

import UIKit

class CInfoLibro: UIViewController, UITextFieldDelegate  {

    public var isbn_sel = ""
    let url:String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    
    @IBOutlet weak var txtIsbn: UITextField!
    
    @IBOutlet weak var titulo: UITextField!
    
    @IBOutlet weak var autores: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var item: Item!
    
    var renglon: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtIsbn.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ( self.isbn_sel.characters.count > 0 ){
            txtIsbn.text = self.isbn_sel
            self.sincrono()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        let strTitulo = titulo.text ?? ""
        
        
        if (self.isbn_sel.characters.count > 0 && strTitulo.characters.count > 0){
            item.titulo = strTitulo
            item.isbn = self.isbn_sel
        }else{
            item.titulo = "Sin datos"
            item.isbn = ""
        }
        
        
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
    
    @IBAction func textFieldDoneEditing(sender: UITextField){
        // Cuando da enter, desaparece el teclado
        self.pull_request()
        sender.resignFirstResponder() //desaparece el teclado
    }
    
    // Cuando hace click fuera de los controles, desaparecer el teclado
    // esta parte la manejamos con
    @IBAction func backgroundTap(sender: UIControl){
        self.txtIsbn.resignFirstResponder()
    }
    
    
    
    func pull_request(){
        if  txtIsbn.text!.characters.count > 0{
            self.isbn_sel = txtIsbn.text ?? ""
            self.sincrono()
        }else{
            self.isbn_sel = ""
        }
        
    }
    
    
    func sincrono(){
        
        if Reachability.isConnectedToNetwork() == true {
            
            let urls = self.url + self.isbn_sel
            let url = URL(string:urls)
            
            
            
            do{
                let datos: Data? = try Data(contentsOf: url!)
                //let texto =  NSString(data: datos!, encoding: NSUTF8StringEncoding)
                let texto = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                let json = texto as! NSDictionary
                
                if (json.allKeys.count > 0){
                    
                    
                    let raiz = json["ISBN:"+self.isbn_sel] as! NSDictionary
                    titulo.text = raiz["title"] as! NSString as String
                    
                   
                    let authors = raiz["authors"] as! NSArray
                    var autors = ""

                    for  author in authors{
                        // print(type(of: author))
                        for (key, value) in author as! NSDictionary {
                            if ("name" == key as! String) {
                                autors = autors + (value as! String) + "\n"
                            }
                        }
                    }
                    autores.text = autors
                    
                    
                    let url = URL(string:"http://covers.openlibrary.org/b/isbn/"+self.isbn_sel+"-M.jpg")
                    let data = try? Data(contentsOf: url!)
                    if data != nil {
                        imageView?.image = UIImage(data:data!)
                    }
                    
                    
                    
                }else{
                    titulo.text = ""
                    autores.text = ""
                }
                
                
            }catch _{
                
            }
            
            
        } else {
            let alert = UIAlertView(title: "No hay conexión a internet", message: "Asegúrese que su dispositivo este conectado a internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        
        
        
    }


}
