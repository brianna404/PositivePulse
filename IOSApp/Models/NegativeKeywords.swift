//
//  NegativeKeywords.swift
//  IOSApp
//
//  Created by Michelle Köhler on 25.08.24.
//

import Foundation

/// Holds a list of negative keywords for sentiment analysis.
struct NegativeKeywords {
    /// List of negative keywords used to identify negative sentiment in text.
    static let list: [String] = [
        "tod", "krieg", "gewalt", "unfall", "mord", "terror", "verbrechen", "katastrophe",
        "verletzte", "opfer", "anschlag", "sturm", "skandal", "korruption", "missbrauch",
        "entlassung", "streit", "verlust", "pleite", "krise", "kollaps", "konflikt",
        "angriff", "protest", "spionage", "drohung", "eskalation", "entschuldigung",
        "rücktritt", "belästigung", "missbrauch", "scheidung", "enttäuschung",
        "ablehnung", "ansteckung", "panik", "trauer", "verzweiflung", "zerstörung",
        "brand", "feuer", "erdbeben", "explosion", "flut", "seuche", "virus", "pandemie", "dürre",
        "hungersnot", "krankheit", "epidemie", "infektion", "entführung", "betrug", "skandal",
        "verletzung", "misshandlung", "folter", "diskriminierung", "rassismus",
        "kriminalität", "sterben", "ermorden", "verletzen", "töt", // Prefix to exclude words starting with "töt-"
        "explodieren", "verunglücken", "zerstören", "betrügen", "missbrauchen",
        "entführen", "ertrinken", "abstürzen", "attackieren", "bombardieren", "erschießen", "sterben", "gestorben", "stirbt",
        "vergiften", "überfallen", "ausrotten",
        "diskriminieren", "tödlich", "schrecklich", "tragisch", "katastrophal", "gewaltsam", "bitter",
        "grausam", "gefährlich", "verheerend", "desaströs", "brutal", "böse",
        "skandalös", "fatal", "unmenschlich", "unheilvoll", "elend", "vernichtend",
        "hoffnungslos", "mörderisch"
    ]
}
