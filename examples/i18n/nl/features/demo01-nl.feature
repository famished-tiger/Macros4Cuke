# language: nl
Functionaliteit: Macro-stappen
  Om gemakkelijker scenarios te kunnen schrijven
  Als Cucumber-gebruiker
  Wil ik macro-stappen kunnen definieëren en toepassen

Scenario: Definitie van een macro-stap (van een scenario)
  Gegeven dat ik de stap "Als ik [de tekst <een_tekst> print]" definieër als:
  """
    Als ik "<een_tekst>" op het scherm afdruk
    En ik bewaar "<een_tekst>" in geheugen
  """
  
Scenario: Gebruik van de macro-stap
  Als ik [de tekst "Hallo" print]
  Dan verwacht ik te zien:
  """
Hallo

  """

  
Scenario: Definitie van een macro-stap dat macro-stap(pen) gebruikt
  Gegeven dat ik de stap "Als ik [de tekst <een_tekst> drie keer print]" definieër als:
  """
  Als ik [de tekst "<een_tekst>" print]
  Als ik [de tekst "<een_tekst>" print]
  Als ik [de tekst "<een_tekst>" print] 
  """
  
Scenario: Gebruik van laatste macro-step
  Als ik [de tekst "Drie maal!" drie keer print]
  Dan verwacht ik te zien:
  """
Drie maal!
Drie maal!
Drie maal!

  """
  