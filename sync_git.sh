#!/bin/bash
#!/bin/sh
# Script pour synchroniser les branches entre elle, les erreurs de commit sont à gérer manuellement

VERSION="2.0"
AUTHOR="Medaey"

# Boucle while pour executer 2 fois le code
nbr=0
while ((cpt<2))
do

# Define each array and then add it to the main one
SUB_0=("master-dev" "Yokta")
SUB_1=("ArchMage" "master-dev")
SUB_2=("lefnouss" "Archmage")
SUB_3=("Medaey" "lefnouss")
SUB_4=("Rafi" "Medaey")
SUB_5=("Yokta" "Rafi")
SUB_6=("master-dev" "Yokta")

MAIN_ARRAY=(
  SUB_0[@]
  SUB_1[@]
  SUB_2[@]
  SUB_3[@]
  SUB_4[@]
  SUB_5[@]
  SUB_6[@]
)

# Loop and print it.  Using offset and length to extract values
COUNT=${#MAIN_ARRAY[@]}
for ((i=0; i<$COUNT; i++))
do
  NAME=${!MAIN_ARRAY[i]:0:1}
  VALUE=${!MAIN_ARRAY[i]:1:1}
  git checkout ${NAME}
  git rebase ${VALUE}
  set timeout 1
  pull origin
  set timeout 1
  push origin
done

((cpt+=1))
done
exit 0