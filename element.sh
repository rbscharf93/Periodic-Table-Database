#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ELEMENT=$($PSQL "
    SELECT elements.atomic_number,
      elements.symbol,
      elements.name,
      types.type,
      properties.atomic_mass,
      properties.melting_point_celsius,
      properties.boiling_point_celsius
    FROM elements
      JOIN properties ON properties.atomic_number = elements.atomic_number
      JOIN types ON types.type_id = properties.type_id
    WHERE CAST(elements.atomic_number as TEXT) = '$1'
      OR elements.symbol = '$1'
      OR elements.name = '$1'
  ;")
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi

# If you run ./element.sh 1, ./element.sh H, or ./element.sh Hydrogen,
# it should output only
# "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, 
# with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius 
# and a boiling point of -252.9 celsius.

