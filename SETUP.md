CHARLIE Connector
=================

Setup
-----
1. Install Chiminey (https://github.com/chiminey/docker-chiminey)
2. Go to docker-chiminey directory
```
	$ cd docker-chiminey
```
3. Enter into the Chiminey container
```
	$ ./chimineyterm
```
4. Go to chiminey directory
```
	$ cd /opt/chiminey/current/chiminey
```
5. Modify the SMART_CONNECTORES dictionary in settings_change.py file to have following:
```
        'marcie':   {'init': 'chiminey.marcieconnector.initialise.MarcieInitial',
                      'name': 'marcie',
                      'description': 'The MARCIE Petri Net Model Checker',
                      'payload': '/opt/chiminey/current/chiminey/marcieconnector/payload_marcie'
                     },
```
6. Modify the INPUT_FIELDS dictionary in settings_change.py file to have following:
```
	'marcie':  SCHEMA_PREFIX + "/input/marcie",
```
7. Clone the git repository https://github.com/alahmedabdullah/marcieconnector.git in /opt/chiminey/current/chiminey
```
	$ git clone https://github.com/alahmedabdullah/marcieconnector.git
```
8. Change ownership of the newly created uppalconnector directory
```
	$ chown -R chiminey.nginx marcieconnector
```
9. Exit from the chiminey container
```
	$ exit
```
10. Restart the chiminey container
```
	$ docker-compose restart chiminey
```
11. Check that marcie connector is listed in available smart connectors list
```
	$ ./listscs
```
12. Activate the marcie connector and follow the prompts
```
	$ ./activatesc marcie
```
