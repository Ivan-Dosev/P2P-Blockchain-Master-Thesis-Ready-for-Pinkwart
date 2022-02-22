//
//  ColorSwitch.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//In the last row is compared also the proposed solution, which is described in more details in the next chapters of this research paper.


import UIKit
import SwiftUI
import MultipeerConnectivity
import CryptoKit
import PromiseKit


extension SendView : ColorServiceDelegate {
  

    func connectedDevicesChanged(manager: ColorService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
//            self.text = "Connections: \(connectedDevices)"
        }
    }
 
    func colorChanged(manager: ColorService, dataModel: Data, peer : MCPeerID) {
        
        OperationQueue.main.addOperation {

            let dataFromModel = try! JSONDecoder().decode(Model.self, from: dataModel)


                if !dataFromModel.peerID.isEmpty {

                    if dataFromModel.isSender {
                        self.signing__ID  = dataFromModel.peerID
                        self.signingID = String(decoding: dataFromModel.peerID, as: UTF8.self)
                            isAnserFromPeer = true
                            ardaPeer = peer
                            imagePreviews = Image(uiImage: UIImage(data: dataFromModel.massige)!)
                            imageDenied   = UIImage(data: dataFromModel.massige)!
                        self.dateNow    = dataFromModel.dateNow
                        self.dateFutuer = dataFromModel.dateFutuer

//               colorService.sendToFistPeer(data: keyAgreenentPublic(), peerID: peer)
//               tozi red e za awtomati4en otgowor

                    }else {
                        self.fromPeer      = dataFromModel.peerTopeer
                        self.peertopeer    = peer.displayName
                        self.agreement__ID = dataFromModel.peerID
                        self.agreementID   =  String(decoding: dataFromModel.peerID, as: UTF8.self)
                        self.dateNow    = dataFromModel.dateNow
                        self.dateFutuer = dataFromModel.dateFutuer
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy"
                        let minute = DateFormatter()
                            minute.dateFormat = "HH:mm:ss"
                        
                        if dataFromModel.dateNow < dataFromModel.dateFutuer {

                            self.stringNow      = "Denied"
                            self.stringFuture   = formatter.string(from: dataFromModel.dateFutuer)
                            self.stringMinute   = minute.string(from: dataFromModel.dateFutuer)
                            
                        }else{
                            
                            self.stringFuture    = formatter.string(from: dataFromModel.dateFutuer)
                            self.stringNow       = formatter.string(from: dataFromModel.dateNow)
                            self.stringMinute    = minute.string(from: dataFromModel.dateNow)
                            
                        }
//                        send data
                            print("B..>>\(dataFromModel.dateFutuer)")
                            print("now..>>\(dataFromModel.dateNow)")
//                        self.dateFutuer = dataFromModel.dateNow
                        print("arda >>>>...\(Date())")

                        colorService.send(data: senderData(date_Future: dataFromModel.dateFutuer, date_Now: dataFromModel.dateNow))
                        saveToCoreData(peer:  peer) { saveToFireBase(strNow:  self.stringFuture  , strFuture:  self.stringNow ,strMinute: stringMinute)
//                        {

//                            if all.count > 0  {
//                            wallet = getWallet(password: password, privateKey: "0b595c19b612180c8d0ebd015ed7c691e82dcfdeadf1733fa561ec2994a4be21", walletName:"metamask")
//                            // Create contract with wallet as the sender
//                            contract = ProjectContract(wallet: wallet!)
//                            // Call contract method
//                            createNewProject(fromPeer: "\(UIDevice.current.name)", toPeer: self.fromPeer, observers: all)
//
//                            print("From :> \(self.fromPeer)")
//                            print("Observer :> \(all)")
//                            }
                //            getProjectTitle()
//                            тук ще зададеш функциата
                            
//                            променлижи: fromPeer = "\(UIDevice.current.name)"
//                                          toPeer = self.fromPeer
//                                        date     = self.stringNow
//                                       свидетели = self.allPeer
                            
                            
//                        }

                        }
                            self.isOkSend = true
                            self.peerString = peer.displayName
                    


//                               saveToFireBase()
                    }

                } else {
                    
                    if !dataFromModel.massige.isEmpty {
                        
                        let formatter = DateFormatter()
//                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        formatter.dateFormat = "dd-MM-yyyy"
                        
                        let minute = DateFormatter()
                            minute.dateFormat = "HH:mm:ss"
    //                    self.selectedDateText = formatter.string(from: self.dateNow)
                        
                        let textData = CryptoData_Array(context: moc)
                            textData.name_Title    = peer.displayName
                        
                        if self.agreement__ID.isEmpty {
                                              textData.key_agreement = privateAgreement_Key.rawRepresentation
                        }else{
                                              textData.key_agreement = self.agreement__ID
                        }
                        if self.signing__ID.isEmpty {
                                              textData.key_public    = privateID_Key.publicKey.rawRepresentation
                        }else {
                                              textData.key_public    = self.signing__ID
                        }
                            textData.peer_To_peer = dataFromModel.peerTopeer
                            textData.key_public    = self.signing__ID
                            textData.crypt_Date    = dataFromModel.massige
                           
                        
                             print("dataFromModel.dateNow = \(dataFromModel.dateNow)")
                             print("dataFromModel.dateFutuer = \(dataFromModel.dateFutuer)")
                        
                        if dataFromModel.dateNow >= dataFromModel.dateFutuer {
                            textData.data_event    = formatter.string(from: dataFromModel.dateFutuer)
                            textData.date_term     = formatter.string(from: dataFromModel.dateNow)
                            textData.minuteMM = minute.string(from: dataFromModel.dateNow)
                            if   self.signingID == "" {
                                textData.index_F   = String(2)
                            }else{
                                textData.index_F   = String(1)
                            }
                            print(">>>>.....>>>>")
                        }else{
                            textData.date_term     = "Denied"
                            textData.data_event    = formatter.string(from: dataFromModel.dateFutuer)
                            textData.minuteMM = minute.string(from: dataFromModel.dateFutuer)
                          
                            if   self.signingID == "" {
                                textData.index_F   = String(2)
                            }else{
                                textData.index_F   = String(5)
                            }
                            print("<<<<<.....<<<<<")
                        }

//                            textData.minuteMM = minute.string(from: dataFromModel.dateNow)
                        
//                        if   self.signingID == "" {
//                            textData.index_F   = String(2)
//                        }else{
//                            textData.index_F   = String(1)
//                        }
                          
                        do {
                                 try self.moc.save()
                        }catch {}
                        
                        self.isOk = true
                        self.peerString = peer.displayName
                        print("\(dataModel)")
           
                    }
                
                    if !dataFromModel.witness.isEmpty {
                    
                    let dataFromWitness = try! JSONDecoder().decode(Witness.self, from: dataFromModel.witness)
                    let textData = CryptoData_Array(context: moc)
                        textData.name_Title    = peer.displayName
                        textData.index_F       = String(4)
                        textData.minuteMM      = dataFromWitness.minuteMinute
                        textData.data_event    = dataFromWitness.dateEvent
                        textData.date_term     = dataFromWitness.dateTerm
                        textData.crypt_Date    = dataFromWitness.cryptWitness
                        textData.peer_To_peer  = dataFromWitness.peerTopeer
                    
                    do {
                             try self.moc.save()
                    }catch {}
                    
                    self.isOk = true
                    self.peerString = peer.displayName
                }
                }


        }
    }
    func change(color : Data) {
//        self.numberID = String(decoding: color, as: UTF8.self)
    }
    func createNewProject(fromPeer: String, toPeer: String, observers: String, date: String, hashedData: String) {

        let parameters = [fromPeer, toPeer, observers, date, hashedData] as [AnyObject]

        firstly {
            // Call contract method
            callContractMethod(method: .writeContract, parameters: parameters,password: "dakata_7b")

        }.done { response in
            // print out response
            print("createNewProject response \(response)")
            // Call out get projectTitle
            self.getProjectTitle()
        }
    }

    func getProjectTitle() {
        
        let parameters = [] as [AnyObject]

        firstly {
            // Call contract method
            callContractMethod(method: .readSenderName, parameters: parameters,password: nil)
        }.done { response in
            // print out response
            print("getProjectTitle response \(response)")
        }
            callContractMethod(method: .readReceiverName, parameters: parameters,password: nil)
            callContractMethod(method: .readObserverName, parameters: parameters,password: nil)
    }
}
