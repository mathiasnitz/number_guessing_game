#!/bin/bash

# Funktion für das Zahlraten-Spiel
GUESSING_GAME() {
  while true; 
  do
    read GUESSED_NUMBER

    if [[ $GUESSED_NUMBER =~ ^[0-9]+$ ]]
    then
      NUMBER_OF_GUESSES=$(( NUMBER_OF_GUESSES + 1 ))

      if [[ $SECRET_NUMBER -gt $GUESSED_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
        
      elif [[ $SECRET_NUMBER -lt $GUESSED_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        
      else
        echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

        $PSQL "UPDATE games SET number_of_guesses=$NUMBER_OF_GUESSES WHERE game_id=$GAME_ID"

        CURRENT_BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID")

        if [[ -z $CURRENT_BEST_GAME ]] || [[ $NUMBER_OF_GUESSES -lt $CURRENT_BEST_GAME ]]
        then
          $PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE user_id=$USER_ID"
        fi

        $PSQL "UPDATE users SET games_played = games_played + 1 WHERE user_id=$USER_ID"

        break
      fi
    else
      echo "That is not an integer, guess again:"
    fi
  done
}

echo "Enter your username:"
read USERNAME

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESSES=0

# Datenbankverbindung in psql
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

if [[ ! -z $USERNAME ]]
then
  # Prüfen, ob der User existiert
  USER_INFO=$($PSQL "SELECT username, user_id, games_played, best_game FROM users WHERE username ILIKE '$USERNAME'")

  if [[ -z $USER_INFO ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."

    # Neuen User anlegen
    $PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 0, NULL)"
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username ILIKE '$USERNAME'")

  else
    # User-Infos auslesen
    IFS="|" read -r USERNAME_DB USER_ID GAMES_PLAYED2 BEST_GAME2 <<< "$USER_INFO"

    GAMES_PLAYED=$($PSQL "SELECT games_played FROM games WHERE user_id=$USER_ID")
    BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id=$USER_ID")

    echo "Welcome back, $USERNAME_DB! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi

  # Neues Spiel für den User anlegen
  $PSQL "INSERT INTO games(user_id) VALUES($USER_ID)"
  GAME_ID=$($PSQL "SELECT game_id FROM games WHERE user_id=$USER_ID ORDER BY game_id DESC LIMIT 1")

  echo "Guess the secret number between 1 and 1000:"
  GUESSING_GAME
fi
