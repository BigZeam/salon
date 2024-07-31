#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to my salon how may I help you?"

MAIN_MENU(){
    #get service list
    LIST=$($PSQL "SELECT * FROM services")
    echo "$LIST" | while IFS="|" read SERVICE_ID_TO_SHOW SERVICE_DISPLAY_NAME
    do
      echo "$SERVICE_ID_TO_SHOW) $SERVICE_DISPLAY_NAME"
    done

    read SERVICE_ID_SELECTED
    #check option against available options
    case $SERVICE_ID_SELECTED in
    1)
    SETUP_APPOINTMENT $SERVICE_ID_SELECTED $SERVICE_DISPLAY_NAME
    ;;
    2)
    SETUP_APPOINTMENT $SERVICE_ID_SELECTED $SERVICE_DISPLAY_NAME
    ;;
    3)
    SETUP_APPOINTMENT $SERVICE_ID_SELECTED $SERVICE_DISPLAY_NAME
    ;;
    *)
    MAIN_MENU
    ;;
    esac
    #restart main menu
}

SETUP_APPOINTMENT(){
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE

  CHECK_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CHECK_PHONE ]]
  then
    echo -e "\nCan I get your name please"
    read CUSTOMER_NAME

    NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like the appointment to be?"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) values($CUSTOMER_ID, $1, '$SERVICE_TIME')")

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $1")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_MENU