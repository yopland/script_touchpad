#! /bin/bash 
######################################################
## TouchpadToggle                                   ##
## Gestion du touchpad avec xinput                  ##
##                                                  ##
## copyleft vgay at vintherine dot org              ##
## version 0.2 du 20140918                          ##
##                                                  ##
## dépendance obligatoire : xorg-xinput             ##
## dépendance optionelle libnotify                  ##
## et xbindkey pour associer ce script à une touche ##
######################################################

### Personnalisation -> mettez ici le nom de votre touchpad tel que trouvé avec la commande xinput.
NomTouchpad="SynPS/2 Synaptics TouchPad"

### Début du script

IFS=$'\n'

if ! command -v xinput >/dev/null; then
  notify-send --icon=dialog-error -t 7000 $Titre "Dépendance xorg-xinput non trouvée" 2>/tmp/touchpadError
  exit 1
fi

Cde[0]="xinput enable "
Cde[1]="xinput disable "
Msg[0]="Touchpad désactivé"
Msg[1]="Touchpad activé"
Titre="Gestion du touchpad :"

DevID=$(xinput | grep "$NomTouchpad" | cut -d"=" -f2 | cut -d $'\x09' -f1)
  if [[ -z $DevID ]]; then
  notify-send --icon=dialog-information -t 5000 $Titre "Touchpad non trouvé"
  exit 0
fi

Enabled=$(xinput list-props $DevID | grep Enabled | tail -c2)

if [[ $1 == "autostart" ]]; then
if (( $(xinput | grep pointer | grep -vc Virtual) < 2 )); then exit 0; fi
fi

Message=$(eval ${Cde[$Enabled]}$DevID 2>&1)
Enabled=$(xinput list-props $DevID | grep Enabled | tail -c2)
if [[ -z $Message ]]; then
  notify-send --icon=dialog-information -t 5000 $Titre ${Msg[$Enabled]}
else
notify-send --icon=dialog-error -t 7000 $Titre $Message
fi
