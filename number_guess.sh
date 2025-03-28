#!/bin/bash

#random number
SECRET_NUMBER=$((RANDOM % 1000 + 1))
echo $SECRET_NUMBER
NUMBER_OF_GUESSES=0

#datenbankverbindung in psql
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo Enter your username:
read USER_NAME

if [[ -z $USER_NAME ]]
then
  USER_INFO=$($PSQL "SELECT username FROM users WHERE username=$USER_NAME")

  if [[ -z $USER_INFO ]]
  then

  echo Welcome, $USER_NAME! It looks like this is your first time here.

  #user zur users tabelle hinzufügen
  ADD_USER_TO_DB=$($PSQL "INSERT INTO users(username, games_played) VALUES('$USER_NAME', 1")

  #user id heraussuchen
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER_NAME'") 

  #ein neues spiel für diesen user in games anlegen
  ADD_GAME=$($PSQL "INSERT INTO games(user_id) VALUES($USER_ID)")

  GUESSING_GAME

  else

  #alle infos über den user heraussuchen
  USER_EXTENDED_INFO=$($PSQL "SELECT user_id, username, game_id, games_played, best_game FROM users, games WHERE 
  username='$USER_NAME' AND games.user_id = users.user_id")


  echo Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
  GUESSING_GAME
  fi

fi

GUESSING_GAME() {
  echo -e "Guess the secret number between 1 and 1000:"
  read GUESSED_NUMBER

  if [[ $GUESSED_NUMBER < $RANDOM_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
    (($NUMBER_OF_GUESSES+=1))
    GUESSING_GAME
  else if [[ $GUESSED_NUMBER > $RANDOM_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
    (($NUMBER_OF_GUESSES+=1))
    GUESSING_GAME
  else
    echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!

    if [[ $NUMBER_OF_GUESSES < $BEST_GAME ]]
    then
      $($PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE username='$USER_NAME'") 
    fi
  fi
}


