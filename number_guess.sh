#!/bin/bash

#random number
SECRET_NUMBER=$((RANDOM % 1000 + 1))
echo $SECRET_NUMBER
NUMBER_OF_GUESSES=0

#datenbankverbindung in psql
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo Enter your username:
read USER_NAME

if [[ ! -z $USER_NAME ]]
then
  USER_INFO=$($PSQL "SELECT username FROM users WHERE username='$USER_NAME'")

  if [[ -z $USER_INFO ]]
  then

    echo Welcome, $USER_NAME! It looks like this is your first time here.

    #user zur users tabelle hinzufügen
    $PSQL "INSERT INTO users(username, games_played) VALUES('$USER_NAME', 1)"

    #user id heraussuchen
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER_NAME'") 

    #ein neues spiel für diesen user in games anlegen
    NEW_GAME_ID=$($PSQL "INSERT INTO games(user_id) VALUES($USER_ID)")

  else

    #alle infos über den user heraussuchen
    USER_EXTENDED_INFO=$($PSQL "SELECT users.user_id, username, game_id, games_played, best_game FROM users, games WHERE 
    username='$USER_NAME' AND games.user_id = users.user_id")

    IFS="|" read -r USER_ID USERNAME GAME_ID GAMES_PLAYED BEST_GAME <<< "$USER_EXTENDED_INFO"

    echo Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
    $PSQL "UPDATE users SET games_played=games_played+1 WHERE user_id=$USER_ID"
    NEW_GAME_ID=$($PSQL "INSERT INTO games(user_id) VALUES($USER_ID)")
  fi

fi

GUESSING_GAME() {
  while true; 
  do

  echo -e "Guess the secret number between 1 and 1000:"
  read GUESSED_NUMBER

  GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games, users WHERE users.user_id = games.user_id AND username='$USER_NAME'")
  echo "Das ist die aktuelle Game-ID von $USER_NAME: $GAME_ID"

  THIS_GAME_ID=$($PSQL "SELECT ")
  NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))

    if [[ $GUESSED_NUMBER -lt $SECRET_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
      $PSQL "UPDATE games SET number_of_guesses=$NUMBER_OF_GUESSES WHERE game_id=$GAME_ID" 
      
    elif [[ $GUESSED_NUMBER -gt $SECRET_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      $PSQL "UPDATE games SET number_of_guesses=$NUMBER_OF_GUESSES WHERE game_id=$GAME_ID" 
    else
      echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!

      if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]] || [[ -z $BEST_GAME ]]
      then
        $PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE username='$USER_NAME'"
      fi

      $PSQL "UPDATE games SET number_of_guesses=$NUMBER_OF_GUESSES WHERE game_id=$GAME_ID" 

      break;
    fi
  done
}

GUESSING_GAME