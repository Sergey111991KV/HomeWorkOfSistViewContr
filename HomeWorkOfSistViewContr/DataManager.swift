//
//  DataManager.swift
//  HomeWorkOfSistViewContr
//
//  Created by Сергей Косилов on 05.08.2019.
//  Copyright © 2019 Сергей Косилов. All rights reserved.
//

import Foundation


class DataManager{
    
    var archiveUrl: URL? {
        guard  let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{ return  nil}
       return documentDirectory.appendingPathComponent("DataImage").appendingPathExtension("data")
        
    }
    
    func loadDataImage()  -> [Data]?{
        guard let archiveUrl = archiveUrl else { return nil}
        guard let encodedData = try? Data(contentsOf: archiveUrl) else { return nil}
                let decoder = PropertyListDecoder()
        if let decodedData = try? decoder.decode([Data].self, from: encodedData){
            
            return decodedData
            }
            print("что то пошло не так")
            return nil
    }
    
    func saveData(_ dataImage: [Data]){
        let encoder = PropertyListEncoder()
        guard let encodedData = try? encoder.encode(dataImage) else { return }
        guard let archiveUrl = archiveUrl else { return }
        try? encodedData.write(to: archiveUrl, options: .noFileProtection)
    }
   
}
