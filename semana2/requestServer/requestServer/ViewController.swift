//
//  ViewController.swift
//  requestServer
//
//  Created by José Manuel Gaytán on 28/08/16.
//  Copyright © 2016 José Manuel Gaytán. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    

    let url:String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    var isbn: String = ""
    
    
    @IBOutlet weak var txtIsbn: UITextField!
    
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autores: UILabel!
    
    
    @IBOutlet weak var imageView: UIImageView!
    var data: NSData?
    
    let imagePicker = UIImagePickerController()
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.pull_request()
        txtIsbn.resignFirstResponder()
        return true
    }
    
    
    func pull_request(){
        if  txtIsbn.text!.characters.count > 0{
            self.isbn = txtIsbn.text!
            self.sincrono()
        }else{
            self.isbn = ""
        }

    }
    
    
        
    func sincrono(){
        
        if Reachability.isConnectedToNetwork() == true {
           
            let urls = self.url + self.isbn
            let url = NSURL(string:urls)
            let datos: NSData? = NSData(contentsOfURL: url!)
            //let texto =  NSString(data: datos!, encoding: NSUTF8StringEncoding)
            
            do{
                let texto = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let json = texto as! NSDictionary
                
                if (json.allKeys.count > 0){
                    let raiz = json["ISBN:"+self.isbn] as! NSDictionary
                    titulo.text = raiz["title"] as! NSString as String
                    
                    let authors = raiz["authors"] as! NSArray
                    var autors = ""
                    for  author in authors{
                        if let autor = author["name"]!{
                            autors = autors + (autor as! String) + " "
                        }
                    }
                    autores.text = autors
                    
                    let url = NSURL(string:"http://covers.openlibrary.org/b/isbn/"+self.isbn+"-M.jpg")
                    data = NSData(contentsOfURL:url!)
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
    
    func asincrono(){
        /* en Info.plist
         <key>NSAppTransportSecurity</key>
         
         <dict>
         
         <!--Permite todas las conexiones (cuidado) -->
         
         <key>NSAllowsArbitraryLoads</key>
         
         <true/>
         
         </dict>
         
         ó
         
         <key>NSAppTransportSecurity</key>
         
         <dict>
         
         <key>NSExceptionDomains</key>
         
         <dict>
         
         <key>dia.ccm.itesm.mx</key>
         
         <dict>
         
         <!--Incluir todos los subdominios-->
         
         <key>NSIncludesSubdomains</key>
         
         <true/>
         
         <!--Para que se pueda realizar peticiones HTTP-->
         
         <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
         
         <true/>
         
         </dict>
         
         </dict>
         
         </dict>
         
         */
        
        let urls = "http://dia.ccm.itesm.mx/"
        let url = NSURL(string:urls)
        let sesion = NSURLSession.sharedSession()
        let bloque = { (datos:NSData?,resp:NSURLResponse?, error: NSError?)-> Void  in
            let texto = NSString(data:datos!, encoding: NSUTF8StringEncoding)
            print(texto!)
        }
        
        let dt = sesion.dataTaskWithURL(url!,completionHandler: bloque)
        dt.resume()
        print("antes o después")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    override func viewDidLayoutSubviews() {
        if data != nil {
            imageView.image = UIImage(data:data!)
        }
    }
    
    
    
   

}

