//
//  LocalFileManager.swift
//  CryptoCourse
//
//  Created by Sergiy Brotsky on 09.06.2022.
//

import Foundation
import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    
    private init() {}
    
    func saveImage(image: UIImage, imageName: String, folderName: String){
        // create folder
        createFolderIfNeeded(folderName: folderName )
        
        // get path to image
        guard
            let data = image.pngData(),
            let url = URL(string: "")
        else {return}
        
        // save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image: \(error) . Image name: \(imageName)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage?{
        guard
            let url = getURLForImage(imageName: imageName, filderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {return nil}
        
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String){
        guard let url = getURLForFolder(filderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path){
            do{
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error{
                print("Error creating folder: \(error) . Folder name: \(folderName)")
            }
        }
        
    }
    
    private func getURLForFolder(filderName: String) -> URL?{
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        
        return url.appendingPathComponent(filderName)
    }
    
    private func getURLForImage(imageName: String, filderName: String) -> URL?{
        guard let folderURL = getURLForFolder(filderName: filderName) else {return nil}
        
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
