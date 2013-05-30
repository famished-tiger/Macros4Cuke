# language: fr
Fonctionnalité: Macro-pas
  Afin d'écrire des scénarios plus facilement
  En tant qu'utilisateur de Cucumber
  Je souhaite pouvoir créer des macro-étapes

Scénario: Définition d'un macro-pas (de scénario)
  Etant donné que je crée le pas "Quand j'[imprime le texte <un_texte>]" qui équivaut à:
  """
    Quand j'imprime "<un_texte>" à l'écran
    Et je garde "<un_texte>" en mémoire
  """
  
Scénario: Utilisation d'un macro-pas (de scénario)
  Quand j'[imprime le texte "Bonjour!"]
  
Scénario: Définition d'un macro-pas appelant des macro-pas!
  Etant donné que je crée le pas "Quand j'[imprime le texte <un_texte> trois fois]" qui équivaut à:
  """
  Quand j'[imprime le texte "<un_texte>"] 
  Quand j'[imprime le texte "<un_texte>"]
  Quand j'[imprime le texte "<un_texte>"]  
  """
  
Scénario: Utilisation du dernier macro-pas (de scénario)
  Quand j'[imprime le texte "Trois fois!" trois fois]
  