//
//  ViewController.swift
//  requestServer
//
//  Created by José Manuel Gaytán on 28/08/16.
//  Copyright © 2016 José Manuel Gaytán. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let url:String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    var isbn: String = ""
    
    
    @IBOutlet weak var txtIsbn: UITextField!
    
    @IBOutlet weak var txtvResponse: UITextView!
    
    
    
    
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
            print("Internet connection OK")
            
            let urls = self.url + self.isbn
            let url = NSURL(string:urls)
            let datos: NSData? = NSData(contentsOfURL: url!)
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            
            txtvResponse.text = texto! as String
            
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
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


}

