NightscoutGarmin
Garmin apps for Nightscout. Intended to use the core nightscout functionality to provide an alternative device option.

The widget can be found in the Garmin app store: https://apps.garmin.com/en-GB/apps/00bde42c-44b6-474e-975c-7c593c6a3bcb

It requires that the Garmin device is connected to a mobile phone running Garmin connect and downloads the data from a specified Nightscout website.

To develop the app you need to follow the instructions on the Garmin website: http://developer.garmin.com/connect-iq/programmers-guide/getting-started/

Import the project, as described for importing samples and you are go.
You might get a compatibility issue if you keep the id in the manifest files the same and try to fork the application, as I get the feeling that garmin uninstalls apps with the same id. This is no tested but something to think about. Note the Garmin developer guidelines that say "Do not edit the manifest"...