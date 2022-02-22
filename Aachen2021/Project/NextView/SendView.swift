//
//  SendView.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//

import SwiftUI
import CryptoKit
import MultipeerConnectivity
import FirebaseStorage
import FirebaseAuth

struct SendView: View {
    @State var isPop : Bool = false
    @ObservedObject var models       = ModelRepository()
    @StateObject var colorService = ColorService()
    @State   var peerString     : String = ""
    @Binding var image          : UIImage?
    @Binding var isWitness      : Bool
    @Binding var isShowingImage : Bool
    @Binding var witness        : Witness
    @Binding var buttonColor    : Int
    let userID = Auth.auth().currentUser?.uid
    let storageRef = Storage.storage().reference().child(Auth.auth().currentUser!.uid + "/" + "\(Date())")
    
    @State          var index = -1
    
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CryptoData_Array.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CryptoData_Array.data_event, ascending: true)]) var cryptoDataArray: FetchedResults<CryptoData_Array>
    
    @Environment(\.presentationMode) var pMode
    
    var privateID_Key : Curve25519.Signing.PrivateKey {
     
         if let data = UserDefaults.standard.data(forKey: "PrivateKey") {
             
               return try! Curve25519.Signing.PrivateKey(rawRepresentation: data)
             
         }else{
               let kay = Curve25519.Signing.PrivateKey()
                         UserDefaults.standard.set( kay.rawRepresentation, forKey: "PrivateKey")
            return kay
         }
     }
     var privateAgreement_Key : Curve25519.KeyAgreement.PrivateKey {
         if let data = UserDefaults.standard.data(forKey: "AgreementKey") {
             
             return try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: data)
             
         }else{
             let kay = Curve25519.KeyAgreement.PrivateKey()
                         UserDefaults.standard.set( kay.rawRepresentation, forKey: "AgreementKey")
            return kay
         }
     }
    @State var allPeers        : String = ""
    @State var fromPeer        : String = ""
    @State var peertopeer      : String = ""
    @State var signingID       : String = ""
    @State var agreementID     : String = ""
    @State var agreement__ID   =  Data()
    @State var signing__ID     =  Data()
    
    @State var dateNow     : Date = Date()
    @State var dateFutuer  : Date = Date()
    @State var selectedDateText : String = ""
    @State var text        : String = ""
    @State var isOnOffSend : Bool = false
    @State var isOk        : Bool = false
    @State var isAnswerOk  : Bool = false
    @State var isOkSend    : Bool = false
    @State var isSendStart : Bool = true
    @State var isNoButton  : Bool = false
    
    @State var isAnserFromPeer : Bool = false
    @State var imagePreviews         : Image = Image("26620")
    @State var imageDenied           : UIImage?
    @State var ardaPeer : MCPeerID = MCPeerID(displayName: UIDevice.current.name)
    @State var dosiPeer : MCPeerID = MCPeerID(displayName: UIDevice.current.name)
    @State var stringNow    : String = ""
    @State var stringFuture : String = ""
    @State var stringMinute : String = ""
    
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .center, spacing: -(spacing_block + lineWidth_block)) {

                VStack(spacing: 0){
                 
                    HStack {
                        
// MARK: - Button exit
                        
                        Button(action: {
                            colorService.stopService()
                            pMode.wrappedValue.dismiss()
                        }) {
                            Text("⏎")
                                .padding()
                                .font(.custom("", size: 12 * button_index ))
                                .frame(width: 70 * button_index , height: 30 * button_index , alignment: .center)
                                .modifier(PrimaryButton(indexRadius: indexRadius))
                        }
                        
                        Spacer()
 
                    }

                    
                    }
                .modifier(Block_Top())
                
                
// MARK: - Date validation
                
                VStack(spacing: 0){
                    HStack{
                        Text("Current date")
                            .modifier(Validation())
                        Spacer()
                        Text("\(selectedDateText)")
                            .modifier(Validation())
                    }
                    HStack{
                        Text("Validity period")
                            .modifier(Validation())
                        DatePicker(selection: $dateNow, in: Date()... , displayedComponents: .date) {}
                            .padding(.horizontal, 20)
                            .accentColor(.white)
                    }
                    

                }
                .modifier(Block_Midle(heightBlock: 0))
                
                if isAnserFromPeer {
                    VStack(spacing: 0){
                       
                        imagePreviews
                            .resizable()
                            .frame(width: width_block, height:  height_block + 350, alignment: .center)
//                            .onTapGesture{
//                                colorService.sendToFistPeer(data: keyAgreenentPublic(), peerID: ardaPeer)
//                            }

                    }
                    .modifier(Block_Midle(heightBlock: 350))

                    
                    VStack(spacing: 0){
                     
                         HStack {
                            
                            Button(action: {
                                
                                 colorService.sendToFistPeer(data: keyAgreenentPublicNo(), peerID: ardaPeer)
                                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                               self.isAnserFromPeer = false
                                 }
                                self.isNoButton = true
                                
                            }) {
                                Text(" No ")
                                    .padding()
                                    .font(.custom("", size: 12 * button_index ))
                                    .frame(width: 70 * button_index , height: 30 * button_index , alignment: .center)
                                    .modifier(PrimaryButton(indexRadius: indexRadius))
                            }
                            
                            Spacer()
                            
                                  Text("Would you confirm")
                            
                            Spacer()
                            
                            Button(action: {
                                           colorService.sendToFistPeer(data: keyAgreenentPublic(), peerID: ardaPeer)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                    self.isAnserFromPeer = false
                                }
                                           
                            }) {
                                Text(" Yes ")
                                    .padding()
                                    .font(.custom("", size: 12 * button_index ))
                                    .frame(width: 70 * button_index , height: 30 * button_index , alignment: .center)
                                    .modifier(PrimaryButton(indexRadius: indexRadius))
                            }
     
                        }

                        
                        }
                    .modifier(Block_Bottom())
                    
                    
                }else{
                    ScrollView(.vertical) {
                        VStack(alignment: .center, spacing: -(spacing_block + lineWidth_block)) {
                            
                            ForEach(Array(zip(colorService.peers, colorService.peers.indices)) , id:\.0) { (peer , index )in
                                
                                VStack(spacing: 0){
                                    
                                    ScrollView{
                                        
                                        Text(peer.displayName)
                                            .foregroundColor(.white)
                                        if  self.isOkSend && self.peerString == peer.displayName {
                                            HStack{
                                                Text("☑️")
                                                Spacer()
                                            }
                                        }
                                        if isOk && self.peerString == peer.displayName{
                                            HStack{
                                                Text("☑️")
                                                    .onAppear(){
                                                              DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                                              pMode.wrappedValue.dismiss()
                                                               models.exitFireBase(user: userID!)
                                                                  }
                                                               }
                                                Spacer()
                                            }
                                        }
                                        
                                        Spacer()
                                            .frame( height: 30)
                                        
    //
    //                                    if isAnserFromPeer {
    //                                        Text("On tap the picture fo ANSWER")
    //                                        imagePreviews
    //                                            .resizable()
    //                                            .frame(width: width_block / 1.05, height:  (height_block + 300) / 1.05, alignment: .center)
    //
    //                                            .onTapGesture{
    //                                                colorService.sendToFistPeer(data: keyAgreenentPublic(), peerID: peer)
    //                                            }
    //                                    }
                                        
    // MARK: - Button send
                                        
                                        ZStack{
                                            if isWitness{
                                                Button(action: {
                                                    witnessSend()
                                                    isWitness = false
                                                    
                                                }) {
                                                    Text("send")
                                                        .padding()
                                                        .font(.custom("", size: 12 * button_index ))
                                                        .frame(width: 70 * button_index , height: 30 * button_index , alignment: .center)
                                                        .modifier(PrimaryButton(indexRadius: indexRadius))
                                                }
                                            }else{
                                                if isShowingImage && isSendStart {
                                                    
                                                    Button(action: {
                                                        
                                                        self.signingID = ""
                                                        self.agreementID = ""
                                                        
                                                        colorService.sendToFistPeer(data: senderSigningPublic(), peerID: peer)
                                                        
                                                        self.isOnOffSend.toggle()
                                                        self.isSendStart = false
                                                        models.exitFireBase(user: userID!)
                                                        
                                                        
                                                    }) {
                                                        Text("Send")
                                                            .padding()
                                                            .font(.custom("", size: 12 * button_index ))
                                                            .frame(width: 70 * button_index , height: 30 * button_index , alignment: .center)
                                                            .modifier(PrimaryButton(indexRadius: indexRadius))
                                                    }
                                                }
                                                

                                            }
                                            

                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                .modifier(Block_Midle(heightBlock: (self.index == index)  ? 50  : 0))

//                                .frame(width: width_block, height:  (self.index == index)  ? height_block + 50  : height_block, alignment: .center)

                                .onTapGesture {
                                    if self.index == index {
                                        self.index = -1
                                    }else{
                                        self.index = index
                                    }
                                }
                                .onAppear(){
                                    self.colorService.delegate = self
                                    colorService.invitePeer(peer)
                                }
                                .onDisappear(){
                                    self.isOkSend = false
                                }
                            }
                            
                            VStack(spacing: 0){
                                                Text("end block")
                            }
                            .modifier(Block_Bottom())
                        }

                    }
                }

                
                
              

                
            }
            .padding(.top, 20)
            .onAppear(){
                setDateString()
            }
            .onDisappear(){colorService.stopService()}
        }
        //mm
    }
    
    
    func senderSigningPublic() -> Data {
        
        let data = image?.jpegData(compressionQuality: 0.5)
        let model = Model(peerID: privateID_Key.publicKey.rawRepresentation, massige: data! ,isSender: true ,dateNow: dateNow, dateFutuer: dateFutuer, peerTopeer: "", witness: Data())
        let modelData = try! JSONEncoder().encode(model)
       return modelData
    }
    
//    func keyAgreenentPublic() -> Data {
//        let model = Model(peerID: privateAgreement_Key.publicKey.rawRepresentation, massige: Data(),isSender: false,dateNow: dateFutuer, dateFutuer: dateNow, peerTopeer: "\(UIDevice.current.name)", witness: Data())
//        let modelData = try! JSONEncoder().encode(model)
//       return modelData
//    }
    func keyAgreenentPublic() -> Data {
        let model = Model(peerID: privateAgreement_Key.publicKey.rawRepresentation, massige: Data(),isSender: false,dateNow: dateNow, dateFutuer: dateFutuer, peerTopeer: "\(UIDevice.current.name)", witness: Data())
        let modelData = try! JSONEncoder().encode(model)
       return modelData
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: "2001-01-01") // replace Date String
    }
    
    func keyAgreenentPublicNo() -> Data {
        let model = Model(peerID: privateAgreement_Key.publicKey.rawRepresentation, massige: Data(),isSender: false,dateNow: getDate()!, dateFutuer: dateFutuer, peerTopeer: "\(UIDevice.current.name)", witness: Data())
        let modelData = try! JSONEncoder().encode(model)
       return modelData
    }
    
    func senderData(date_Future : Date, date_Now : Date) -> Data {
        
        let data = image?.jpegData(compressionQuality: 0.5)
        let receiverEncryptionPublicKey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: agreement__ID)
        let sealedMessage = try! encrypt(data!, to: receiverEncryptionPublicKey, signedBy: privateID_Key)

  let model = Model(peerID: Data(), massige: sealedMessage, isSender: true,dateNow: date_Now, dateFutuer: date_Future, peerTopeer: self.peertopeer, witness: Data())
        
    let modelData = try! JSONEncoder().encode(model)
        return modelData
    }
    
    func saveToCoreData(peer : MCPeerID, onSelect: () -> Void) {
        let data = image?.jpegData(compressionQuality: 1.0)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let minute = DateFormatter()
            minute.dateFormat = "HH:mm:ss"
//                    self.selectedDateText = formatter.string(from: self.dateNow)
        
        let textData = CryptoData_Array(context: moc)
            textData.peer_To_peer  = ""
            textData.name_Title    = peer.displayName
            textData.key_agreement = self.agreement__ID
            textData.key_public    = self.signing__ID
            textData.crypt_Date    = data
        
           
        
        if self.dateNow >= self.dateFutuer {
            textData.data_event    = formatter.string(from: self.dateFutuer)
            textData.date_term     = formatter.string(from: self.dateNow)
        }else{
            textData.date_term     = "Denied"
            textData.data_event    = formatter.string(from: self.dateFutuer)
        }
            
            textData.minuteMM      = minute.string(from: self.dateFutuer)
            textData.index_F       = String(3)

          
        do {
                 try self.moc.save()
            
                          onSelect()
        }catch {}
    }
    
//    func saveDenied() {
//        let data = imageDenied?.jpegData(compressionQuality: 1.0)
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM dd, yyyy"
//        let minute = DateFormatter()
//            minute.dateFormat = "HH:mm:ss"
////                    self.selectedDateText = formatter.string(from: self.dateNow)
//
//        let textData = CryptoData_Array(context: moc)
//            textData.peer_To_peer  = ""
//            textData.name_Title    = ardaPeer.displayName
//            textData.key_agreement = self.agreement__ID
//            textData.key_public    = self.signing__ID
//            textData.crypt_Date    = data
//            textData.data_event    = formatter.string(from: self.dateNow)
//            textData.date_term     = "Denied"
//            textData.minuteMM      = minute.string(from: self.dateNow)
//            textData.index_F       = String(5)
//
//
//        do {
//                 try self.moc.save()
//
//        }catch {}
//    }
     
    func witnessSend() {
        
        for peer in colorService.peers {
            if peer.displayName == witness.peerTopeer {
                colorService.sendToFistPeer(data: witnessSet(), peerID: peer)
            }
        }
    }
    
    func witnessSet()-> Data {
        
         let witnessData =  try! JSONEncoder().encode(witness)
         let model = Model(peerID: Data(), massige: Data(), isSender: false ,dateNow: dateNow, dateFutuer: dateFutuer, peerTopeer: self.peertopeer, witness: witnessData )
         let modelData = try! JSONEncoder().encode(model)
         return modelData
    }
    
    
    func   saveToFireBase(strNow : String, strFuture: String, strMinute: String){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let minute = DateFormatter()
            minute.dateFormat = "HH:mm:ss"
        
        print("self.dateNow    = \(self.dateNow)")
        print("self.dateFutuer = \(self.dateFutuer)")
        
        let data = image?.jpegData(compressionQuality: 0.5)
        let receiverEncryptionPublicKey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: agreement__ID)
        let sealedMessage = try! encrypt(data!, to: receiverEncryptionPublicKey, signedBy: privateID_Key)


        
        do{
            
            let _ = try! storageRef.putData( sealedMessage, metadata: nil) { (metadata , error ) in
                
                guard let metadata = metadata else {
                    print("error metadada ...")
                    return
                }
                let size = metadata.size
                
                print("size = \(size)")
                DispatchQueue.main.async { [self] in
                    storageRef.downloadURL{( url , err ) in
                        guard let downloadURL = url else {
                            print("error .. >> url")
                            return
                        }
                        print("url >> \(downloadURL.relativeString)")
                        self.allPeers = ""
                        
                        for mod in models.allModels {
                            print("dossi = \(mod.authNumber)")
                            self.allPeers += " \(mod.authPhone)"

//                            models.saveToPeerInFierbase(user: mod.authNumber, title: "\(downloadURL)", fromPEER: "\(UIDevice.current.name)", toPEER: self.fromPeer, idDownloud: true, data_event: formatter.string(from: self.dateNow),date_term: formatter.string(from: self.dateFutuer), minuteMM:  minute.string(from: self.dateNow))
                            
                            models.saveToPeerInFierbase(user: mod.authNumber, title: "\(downloadURL)", fromPEER: "\(UIDevice.current.name)", toPEER: self.fromPeer, idDownloud: true, data_event: strNow,date_term: strFuture, minuteMM:  strMinute)
                        }

                        let hashedValue = SHA256.hash(data: data!)
                        print("Hashed Value: \(hashedValue)")

                        print("AllPeers: \(allPeers)")
                        wallet = getWallet(password: password, privateKey: "0b595c19b612180c8d0ebd015ed7c691e82dcfdeadf1733fa561ec2994a4be21", walletName:"metamask")
                        // Create contract with wallet as the sender
                        contract = ProjectContract(wallet: wallet!)
                        // Call contract method
                        createNewProject(fromPeer: "\(UIDevice.current.name)", toPeer: self.fromPeer, observers: allPeers, date: "\(self.stringNow + " " + self.stringMinute)", hashedData: "\(hashedValue)")
                    }
                }
            }
        } catch{
            print("error putData ...")
        }
    }
    
    
    private func setDateString() {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      self.selectedDateText = formatter.string(from: self.dateNow)
    }
}

struct SendView_Previews: PreviewProvider {
    static var previews: some View {
//        SendView()
        Text("aa")
    }
}
