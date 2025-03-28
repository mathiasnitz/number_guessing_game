#!/bin/bash

#random number
SECRET_NUMBER=$((RANDOM % 1000 + 1))
#echo $SECRET_NUMBER
NUMBER_OF_GUESSES=0

#datenbankverbindung in psql
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo Enter your username:
read USERNAME

if [[ ! -z $USERNAME ]]
then
  USER_INFO=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")

  if [[ -z $USER_INFO ]]
  then

    echo "Welcome, $USERNAME! It looks like this is your first time here."

    #user zur users tabelle hinzufügen
    $PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 1, NULL)"

    #user id heraussuchen
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'") 

    #ein neues spiel für diesen user in games anlegen
    NEW_GAME_ID=$($PSQL "INSERT INTO games(user_id) VALUES($USER_ID)")

  else

    #alle infos über den user heraussuchen
    USER_EXTENDED_INFO=$($PSQL "SELECT users.user_id, username, game_id, games_played, best_game FROM users, games WHERE 
    username='$USERNAME' AND games.user_id = users.user_id")

    IFS="|" read -r USER_ID USERNAME GAME_ID GAMES_PLAYED BEST_GAME <<< "$USER_EXTENDED_INFO"

    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

    $PSQL "UPDATE users SET games_played=games_played+1 WHERE user_id=$USER_ID"
    NEW_GAME_ID=$($PSQL "INSERT INTO games(user_id) VALUES($USER_ID)")
  fi

fi

GUESSING_GAME() {
while true; 
do
  
  read GUESSED_NUMBER

  if [[ $GUESSED_NUMBER =~ ^[0-9]+$ ]]
  then

    GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games, users WHERE users.user_id = games.user_id AND username='$USERNAME'")

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

        if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]] || [[ -z $BEST_GAME ]]
        then
          $PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE username='$USERNAME'"
        fi

        $PSQL "UPDATE games SET number_of_guesses=$NUMBER_OF_GUESSES WHERE game_id=$GAME_ID" 

        echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!

        break;
      fi
  else
    echo "That is not an integer, guess again:"
  fi
done
}

echo "Guess the secret number between 1 and 1000:"
GUESSING_GAME