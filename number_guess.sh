#!/bin/bash

#random number
SECRET_NUMBER=$((RANDOM % 1000 + 1))
echo $SECRET_NUMBER

#datenbankverbindung in psql
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo Enter your username:
read USER_NAME

if [[ -z $USER_NAME ]]
then
  USER_INFO=$($PSQL "SELECT username FROM users WHERE username=$USER_NAME")

  if [[ -z $USER_INFO ]]
  then
  ADD_USER_TO_DB=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USER_NAME', 1, NULL")
  echo Welcome, $USER_NAME! It looks like this is your first time here.
  GUESSING_GAME

  else

  USER_EXTENDED_INFO=$($PSQL "SELECT user_id, username, game_id, games_played, best_game FROM users WHERE username='$USER_NAME'")


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
    GUESSING_GAME
  else if [[ $GUESSED_NUMBER > $RANDOM_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
    GUESSING_GAME
  else
    echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER
  fi
}


