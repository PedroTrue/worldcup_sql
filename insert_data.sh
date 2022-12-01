#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND W O WG OG

do
  if [[ $W != 'winner' ]]
  then
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$W'")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$W')")
      if [[ $INSERT_TEAM == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $W
      fi
    fi
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$W'")
  fi
  if [[ $O != 'opponent' ]]
  then
    TEAM_2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$O'")
    if [[ -z $TEAM_2_ID ]]
    then
      INSERT_2_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$O')")
      if [[ $INSERT_2_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $O
      fi
    fi
    TEAM_2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$O'")
  fi
  if [[ $YEAR != 'year' ]]
  then
    INSERT_GAME_ID=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID, $TEAM_2_ID, $WG, $OG)")
    if [[ $INSERT_GAME_ID == "INSERT 0 1" ]]
    then
      echo Inserted game_id '\o/'
    fi
  fi
done