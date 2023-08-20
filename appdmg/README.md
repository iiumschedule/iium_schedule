# .dmg creator

This folder (appdmg) serves necessary file to create a .dmg file for the app.

## Prerequisites

- Make sure node is installed
- Install appdmg tool: `npm install -g appdmg`

## Create a .dmg file

> **Note**: Configuration file and assets needed to build the dmg are located in this folder (appdmg)

- Build macos Flutter app: Make sure you're on Mac laptop. Run `flutter build macos` in the root folder of the project.
- Change directory to `/appdmg` folder by running `cd appdmg`.
- Run `appdmg <config-json-path> <output-dmg-path-with-file-name>` in this folder. For example: `appdmg config.json ./IIUMSchedule.dmg`

## Credits

Tutorial - https://retroportalstudio.medium.com/creating-dmg-file-for-flutter-macos-apps-e448ff1cb0f
appdmg tool - https://www.npmjs.com/package/appdmg
