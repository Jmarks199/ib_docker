# ib_docker
A Docker Container for the Interactive Brokers Gateway in a Headless Environment. Supports running both Live and Paper Environments.

As of 11/25/2020 I did not see any other currently working examples of building a docker container for the IB Gateway on Github. In order to create run this Docker container you will need to have the Docker and Docker-Compose CLI components installed on your machine.

### Notes
    * This will make the IB Gateway available on your local machine on port 4003 regardless of whether you run the container in paper or live mode.
      * This implies you cannot run more than one container at a time. Although with minimal changes I suppose you could.
    * After you run the container, you need to wait 30 seconds before trying to connect to port 4003 because this is the amount of time provided for the IB Gateway to start before the ports are forked inside the container.

### Configuration
1. Clone this repository onto your local machine.
2. Review the settings in *config.ini* so you understand the behavior of the gateway and change if necessary.
3. Open a text editor and create a file called *tws_credentials.env* inside the context directory and insert the username and password you use to login to Interactive Brokers
     * Refer to the example file if necessary.
     * This is included in the .gitignore so it will not be pushed to your source control but your password is still stored as plain text on your local machine so take necessary precaution to protect this file.
     * Note - i use the same ID and password for both live and paper, but you could create two .envs, remove the env_file section from *common-services.yml* and add the appropriate .env file to the env_file section in each *docker-compose* yml file.
  
 ### To Build and Run
 Then, follow these steps to build a Docker Image and run the container.
 
 1. cd into the context directory (where the Dockerfile lives)
 2. Run `docker-compose build` in the console
 3. Run `docker-compose up` to start the container with *TRADING_MODE* set to paper. 
     * To run the container with trading mode set to live run `docker-compose -f docker-compose-live.yml up` instead
 4. Connect to the IB Gateway from your local machine with `ipaddress="127.0.0.1", portid=4003`
     * Traditionally you can connect to IB Gateway locally by specifying `ipaddress=""`, however, this would not work for me.
 
 ### Telnet
 I have not tested shutting down the container via Docker, however telnet is installed in the container so you can communicate with the IBC service on port 7462 e.g. `{ echo "STOP"; } | telnet 127.0.0.1 7462` in order to close the IB Gateway.
 
 ### Final
 If you see any issues or improvements, please let me know.
 
 
