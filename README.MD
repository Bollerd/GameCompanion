# Game Companion / Spiele Begleiter

Historisch ist diese App eine meiner ersten Entwicklungen. Sie stammt noch aus der Zeit, als unsere Kinder wesentlich kleiner waren und diente zum Zeitvertreib im Restaurant oder im Urlaub. Einfach per Pass&Play am gleichen iPhone  gegeneinander "Stadt, Land, Fluss" spielen oder wenn man Uno Karten dabei hat, kann man über die App die Reihenfolge der Spieler zufällig bestimmen lassen. Dann zieht eventuell nicht der Spieler auf der rechten Seite die Karten, sondern die Person selbst, die die entsprechende Karte gespielt hat.

## App Funktionen

### Einstellungen

Die Fragen für Stadt, Land, Fluss, die Anzahl der Würfel oder der maximalen Würfelpunktzahl oder Leben kann in den Einstellungen geändert werden.

### Spielerverwaltung

Es können die Namen von Spielern gepflegt werden. Pro Spieler kann über einen Schalter die Person als aktiv oder inaktiv markiert werden. Sprich bei einer Spielrunde macht jemand nicht mit und der Name muss nicht aus der Liste gelöscht werden. Die Reihenfolge der Spieler kann per Drag und Drop verändert werden.

### Punkteverwaltung

Für jeden Spieler kann eine Punktzahl pro Runde notiert werden. Kann man für Spiele wie 5000 nutzen.

### Würfeln

Die App würfelt für den aktuellen Spieler mit den zuvor definierten Anzahl von Würfeln und Seitenzahl. Es kann neu gewürfelt werden und es werden alle Würfel neu gewürfelt, die nicht markiert wurden, dass diese nicht mehr gewürfelt werden sollen. Zu nutzen für eigentlich jedes Würfelspiel wie 5000, Kniffel, Yatzee...

### Leben

Jeder Spieler hat eine bestimmte Anzahl Leben und wenn diese 0 ist, ist eine Person ausgeschieden. Kann man für Spiele wie Mäxchen oder Schwimmen nutzen.

### Wer ist dran?

Aus der Liste der aktiven Spieler wird per Zufall der nächste Spieler gewählt. Damit kann man dann zB Uno oder Maumau spielen ohne zu wissen wer als nächstes am Zug ist. Wenn ein Spieler keine Karten mehr hat kann man dies angeben und der Zufallsgenerator sucht dann nur noch aus den verbleibenden Spielern den nächsten aus.

### Triff die Zielscheibe

Entspricht sozusagen der digitalen Umsetzung der Hamster, die aus dem Loch schauen und getroffen werden müssen. Sowas gab es früher auf dem Jahrmarkt oder im Freizeitpark. Schnell genug antippen bevor er wieder verschwindet.

## Technische Informationen

Die Daten der App werden per iCloud zwischen allen Geräten des gleichen Accounts synchronisiert. Technisch ist dies bei der App über die einfachste Speicherart, die Userdefaults gelöst.

Für die Würfelfunktion wird eine einfache Swift UI Animation verwendet die den grauen Würfel an den Ecken flippt und die neue Zahl wird am Ende der Animation angezeigt.

Der Quellcode ist sicher nicht optimal, da die App über einen längeren Zeitraum immer wieder angepasst wurde und neue oder andere Funktionen erhalten hat.

## Notwendige Anpassungen
Die App kann mit dem vorhandenen Code aus Github direkt 1:1 verwendet werden. 

## App Screenshots

### Übersicht
![Übersicht](https://ios.dbweb.info/wp-content/uploads/2024/11/gamecompanion1-scaled.jpg)

### Einstellungen
![Einstellungen](https://ios.dbweb.info/wp-content/uploads/2024/11/gamecompanion2-scaled.jpg)

### Einstellungen Spieler
![Einstellungen Spieler](https://ios.dbweb.info/wp-content/uploads/2024/11/gamecompanion3-scaled.jpg)

### Einstellungen Stadt, Land, Fluss
![Einstellungen Stadt, Land, Fluss](https://ios.dbweb.info/wp-content/uploads/2024/11/gamecompanion4-scaled.jpg)

### Starte Stadt, Land, Fluss
![Starte Stadt, Land, Fluss](https://ios.dbweb.info/wp-content/uploads/2024/11/gamecompanion5-scaled.jpg)

### Spiele Stadt, Land, Fluss
![Spiele Stadt, Land, Fluss](https://ios.dbweb.info/wp-content/uploads/2024/11/gamecompanion6-scaled.jpg)

### Leben pro Spieler
![Leben pro Spieler](https://ios.dbweb.info/wp-content/uploads/2024/11/gamecompanion7-scaled.jpg)

### Triff die Zielscheibe
![Triff die Zielscheibe](https://ios.dbweb.info/wp-content/uploads/2024/11/gamecompanion8-scaled.jpg)

### Wer ist dran
![Wer ist dran](https://ios.dbweb.info/wp-content/uploads/2024/11/gamecompanion9-scaled.jpg)