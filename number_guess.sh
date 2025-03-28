#!/bin/bash

echo "Enter your username:"
read USERNAME

#secret number
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

NUMBER_OF_GUESSES=0

#datenbankverbindung in psql
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

if [[ ! -z $USERNAME ]]
then

  USER_INFO=$($PSQL "SELECT username FROM users WHERE username ILIKE '$USERNAME'")

  if [[ -z $USER_INFO ]]
  then

    echo "Welcome, $USERNAME! It looks like this is your first time here."

    #user zur users tabelle hinzufügen
    $PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 1, NULL)"

    BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username ILIKE '$USERNAME'")

    #user id heraussuchen
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username ILIKE '$USERNAME'") 

    #ein neues spiel für diesen user in games anlegen
    NEW_GAME_ID=$($PSQL "INSERT INTO games(user_id) VALUES($USER_ID)")

  else

    #alle infos über den user heraussuchen
    USER_EXTENDED_INFO=$($PSQL "SELECT user_id, username, games_played, best_game FROM users WHERE 
    username ILIKE '$USERNAME'")

    IFS="|" read -r USER_ID USERNAME_DB GAMES_PLAYED BEST_GAME <<< "$USER_EXTENDED_INFO"

    echo "Welcome back, $USERNAME_DB! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

    $PSQL "UPDATE users SET games_played=games_played+1 WHERE user_id=$USER_ID"
    $PSQL "INSERT INTO games(user_id) VALUES($USER_ID)"
  fi

  echo "Guess the secret number between 1 and 1000:"

fi

GUESSING_GAME() {
while true; 
do

  read GUESSED_NUMBER

  if [[ $GUESSED_NUMBER =~ ^[0-9]+$ ]]
  then

    NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))

    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE user_id=$USER_ID ORDER BY game_id DESC LIMIT 1")

    if [[ $SECRET_NUMBER -gt $GUESSED_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
      $PSQL "UPDATE games SET number_of_guesses=$NUMBER_OF_GUESSES WHERE game_id=$GAME_ID" 
        
    elif [[ $SECRET_NUMBER -lt $GUESSED_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      $PSQL "UPDATE games SET number_of_guesses=$NUMBER_OF_GUESSES WHERE game_id=$GAME_ID" 

    elif [[ $SECRET_NUMBER -eq $GUESSED_NUMBER ]]
    then

      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

      $PSQL "UPDATE games SET number_of_guesses=$NUMBER_OF_GUESSES WHERE game_id=$GAME_ID"

      if [[ -z $BEST_GAME || $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
      then
        $PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE user_id=$USER_ID"
      fi
      break;
    fi
  else
    echo "That is not an integer, guess again:"
  fi
done
}

GUESSING_GAME