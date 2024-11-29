//
//  SLFQuestions.swift
//  gameCompanion
//
//  Created by Dirk Boller on 27.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import Foundation

/// Object for the SLF questions
class SLFQuestion: Identifiable {
    let id = UUID()
    let question: String
    @Published var enabled = true
  
    init(question: String) {
        self.question = question
    }
}

let SLF_SONSTIGES = ["Kleidungsstück","Farbe","Schimpfwort","Gegenstand kleiner/größer als XY","Gegenstand auf dem Schreibtisch","technischer Gegenstand","Werkzeug","Kosmetikprodukt","bekanntes Unternehmen","Modemarke","Automarke"]
let SLF_KINDER = ["Süßigkeit","Spielzeug","Sänger/Sängerin","Fußballverein","Märchenfigur","Comicfigur","Haustiernamen"]
let SLF_UNTERHALTUNG = ["Zeitung/Zeitschrift","Superhelden","Disney-Figur","fiktiver Charakter","App","Buch","Trash-TV","TV-Sender","Fernsehsendung","Lied","Filme"]
let SLF_MENSCH = ["Grund zum Feiern","Grund zum Schwänzen","Grund fürs Zuspätkommen","Kündigungsgrund","Trennungsgrund","Todesursache","Schulfach/Studienfach","Fortbewegungsarten","Krankheit","Spitzname","Sprache","Sportart","Hobby","Gefühl","Körperteil","Nachname","Vorname"]
let SLF_ESSENUNDTRINKEN = ["Kräuter","Supermärkte","Bars","Restaurants","Fast Food","Kuchen","Frühstück","Pizzabelag","Eissorten","alkoholische Getränke","Cocktails","Hauptgericht","Biersorten","Gewürze","Softdrinks","Gemüse","Obst","Süßigkeiten"]
let SLF_NATUR = ["Meerestier","Baum","Naturkatastrophen","Blumen","Pflanze","Pilzsorte","Fischart","Insekt","Vogelart ","Katzenrasse","Hunderasse","Wald","Insel","See","Meer","Gebirge/Berg"]
let SLF_PERSÖNLICHKEITEN = ["berühmter Toter","Historische Persönlichkeit","AutorIn","KünstlerIn","PolitikerIn","SportlerIn (Allgemein)","FußballerIn","SchauspielerInnen","Model","Bands","SängerInnen","Z-Promis","Promis"]

