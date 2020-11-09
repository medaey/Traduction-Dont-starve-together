#!/bin/bash
#!/bin/sh
# Script pour synchroniser les branches entre elle, les erreurs de commit sont à gérer manuellement

VERSION="2.4"
AUTHOR="Medaey"
CONTRIBUTOR="Doot"
BRANCH_LIST="branch_list.txt"
BRANCH_LIST_DESCALER="branch_list_descaler.txt"

recerper_branch="master-dev"   # La branch qui va recevoir toutes les modifications

create_lists(){   # Liste les branch dans 2 fichiers
  git checkout master
  git branch -i > $BRANCH_LIST         # Récuperer la liste des branch
  sed -i 's/ //g' $BRANCH_LIST         # Supprimer les espace
  sed -i 's/*master//g' $BRANCH_LIST   # Supprimer *master de la list
  sed -i 's/'$recerper_branch'//g' $BRANCH_LIST   # Supprimer $recerper_branch de la list
  sed -i '/^$/d' $BRANCH_LIST                     # Supprimer les sauts de ligne
  sed -i '1i'$recerper_branch'' $BRANCH_LIST      # Ajoute $recerper_branch à la list
  sed '$d' $BRANCH_LIST > $BRANCH_LIST_DESCALER   # Clone la BRANCH_LIST et supprime le dernière ligne pour crée le fichier BRANCH_LIST_DESCALER
  sed -i '1i'$(awk 'END {print}' $BRANCH_LIST)'' $BRANCH_LIST_DESCALER   # Déplace la dernier ligne à la 1er place
}

git_sync(){
  cpt=1
  while ((cpt<$(git branch -i | grep -c '')))   # Compte le nombre de branch dans le projet
  do
      git checkout $(sed -n "$cpt"p $BRANCH_LIST)
      git rebase $(sed -n "$cpt"p $BRANCH_LIST_DESCALER)
      git pull origin
      git push origin
      ((cpt+=1))
    done
}

clear_list(){
  rm $BRANCH_LIST $BRANCH_LIST_DESCALER   #Supprime les fichiers listes
}

# Appels des fonctions
create_lists   # Liste les branch du projet
git_sync       # Synchronise des branch entre elles
git_sync       # 2éme sync pour mettre à jour de la branch $recerper_branch
clear_list     # Suppression des fichiers listes
exit 0