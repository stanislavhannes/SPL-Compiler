# SPL-Compiler
Ein Compiler für die einfache prozedurale Programmiersprache [SPL 1.2](https://homepages.thm.de/~hg52/lv/compiler/praktikum/SPL-1.2.html) für die RISC Zielmaschine [ECO32](https://homepages.thm.de/~hg53/eco32/).  
Geschrieben in Java.  
SPL ("Simple Programming Language") -----> ASM (Assembler)  -----> BIN (Binär für den ECO32)


# Compiler Verwenden

1. Mit einem ``make`` die Java *.class Dateien kompilieren
2. Programm kompilieren mit ``./spl [INPUT] [OUTPUT]`` z.B.
``./spl TOOLS/SPL\ Programme/acker.spl TOOLS/Compiler\ Output/acker.asm``

# Mit Referenz Compiler das SPL Programm starten

1. SPL-Quelldateien muessen die Endung '.spl' tragen, falls Sie
   die mitgelieferten Shellscripte verwenden wollen.

2. Übersetzen einer SPL-Quelldatei am Beispiel 'queens' und im Verzeichnis unter  
*./TOOLS/ECO32 Simulator & SPL Referenz Compiler*: 
 
   ``./compile queens.spl``  
   Dabei werden folgende Dateien erzeugt:
   * queens.asm  -  Output des Compilers (= queens in Assembler)
   * queens.obj  -  Output des Assemblers (= queens im Bindeformat)
   * queens.bin  -  Output des Binders (= queens im Binaerformat)
   * queens.map  -  Lademap des queens-Programms (= wo ist welche Prozedur?)

3. Laufenlassen eines uebersetzten Programms am Beispiel 'queens':
   ``./run queens.bin``
   Es wird damit der ECO32-Simulator gestartet und 'queens.bin' in den
   simulierten Hauptspeicher geladen. Mit dem Simulator-Kommando 'c'
   (continue) starten Sie Ihr Programm.
   Ein laufendes, beendetes oder auch abgestuerztes Programm koennen
   Sie mit der Tastenkombination 'Ctrl-C' im Simulator-Kontrollfenster
   anhalten.
   Zum Verlassen des Simulators gibt's das Kommando 'q' (quit).
   Mit '?' koennen Sie sich alle Kommandos des Simulators anzeigen
   lassen.

4. Laufenlassen eines Programms mit Grafik geht genauso; Sie muessen
   nur anstelle von 'run' das Script 'rungraph' verwenden.   
   Es ruft den Simulator mit der zusaetzlichen Option '-g' auf; diese installiert
   den Grafik-Controller im simulierten Rechner.


# Contributing
* Prof. Dr. Hellwig Geisse (ECO32)
* Prof. Dr. Michael Jäger (Skeleton & Referenz Compiler)
* [JFlex](https://homepages.thm.de/~hg52/lv/compiler/praktikum/jflex-manual.html) (Scannergenerator)


# Lizenz
[![Creative Commons Lizenzvertrag](https://i.creativecommons.org/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/)  