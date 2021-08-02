//
//  GPXManager.swift
//  Path
//
//  Created by Kieran on 29/07/2021.
//

import Foundation

import CoreGPX

class GPXManager: Identifiable{
    func start() -> GPXRoot{
        let url = Bundle.main.url(forResource: "gwyneddWhole", withExtension: ".gpx")!
        guard let gpx = GPXParser(withURL: url)?.parsedData() else { return GPXRoot()}
        return gpx
    }
}
