#!/bin/bash


ENTER_USERNAME() {
  echo "Enter your username:"
  read USERNAME
}

ENTER_USERNAME

#secret number
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESSES=0

#datenbankverbindung in psql
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align --quiet -c"

GUESSING_GAME() {

GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games WHERE user_id=$USER_ID")
$PSQL "UPDATE users SET games_played=games_played+1 WHERE user_id=$USER_ID"

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
      
    elif [[ $SECRET_NUMBER -eq $GUESSED_NUMBER ]]
    then

      $PSQL "UPDATE games SET number_of_guesses=$NUMBER_OF_GUESSES WHERE game_id=$GAME_ID"

      if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]] || [[ -z $BEST_GAME ]]
      then
        $PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE user_id=$USER_ID"
      fi

      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

      break;
    fi
  else
    echo "That is not an integer, guess again:"
  fi
done
}



if [[ ! -z $USERNAME ]] && [[ ! ${#USERNAME} -gt 22 ]]
then

  USER_INFO=$($PSQL "SELECT username FROM users WHERE username ILIKE '$USERNAME'")

  if [[ -z $USER_INFO ]]
  then

    echo "Welcome, $USERNAME! It looks like this is your first time here."

    #user zur users tabelle hinzufügen
    $PSQL "INSERT INTO users(username, games_played) VALUES('$USERNAME', 0)"
    #user id heraussuchen
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username ILIKE '$USERNAME'")

    BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id=$USER_ID")

  elif [[ ! -z $USER_INFO ]]
  then

    #alle infos über den user heraussuchen
    USER_EXTENDED_INFO=$($PSQL "SELECT user_id, username FROM users WHERE 
    username ILIKE '$USERNAME'")

    USERNAME_DB=$($PSQL "SELECT username FROM users WHERE username ILIKE '$USERNAME'")

    IFS="|" read -r USER_ID USERNAME_DB2 <<< "$USER_EXTENDED_INFO"

    GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id=$USER_ID")
    BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id=$USER_ID")

    

    

    echo Welcome back, $USERNAME_DB! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
    
  fi

  $PSQL "INSERT INTO games(user_id) VALUES($USER_ID)"

  echo "Guess the secret number between 1 and 1000:"
  GUESSING_GAME
else
  echo "Username not allowed. Ending."
  ENTER_USERNAME
fi



