# HSERemoteAccelerometer
This app simply gets devise's Accelerometer and Gyroscope data and push them to the remote database.
App let you interact with your own DB. Just configure the id address
---
## Installation
[App in AppStore](https://appsto.re/ru/etlMkb.i)

---
## Configure connection
Before sending the data you have to configure the connection params:
- User name. The user name you have configured on the server
- Password. The password you have configured on the server
- Database name. The name of your InfluxDB database
- IP Address. With mask: "\*\*.\*\*\*.\*\*\*.\*\*:\*\*\*\*"
---
## Usage
> Note: App works only with InfluxDB API. If you want to use anuther service, go to NetworkManager.m file and change API requests

App sends records to a server with a cycle. You can configure the sending frequency or send it before time is over
#### Accelerometer and Gyroscope
Both Accelerometer and Gyroscope uses a coordinate system of a device
![alt text](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/DesigningExpandedAdUnits/Art/ch4_15axes.png "Logo Title Text 1")
#### Accelerometer
Tracks device position in space as a material point
#### Gyroscope
Tracks how do user twists a device

---
## Requirements
iOS 10

---
## Support
dmitriytitov96@gmail.com
