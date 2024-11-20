#!/bin/bash

SECRET="ntfy_username:ntfy_password"
URL="https://your.ntfy.url/topic"

if [[ $EUID -ne 0 ]]; then
        echo -e "[\e[31mERROR\e[0m] You must be root to do this"
        exit 1
fi

TIME="[$(date +"%d/%m/%Y %H:%M:%S")]"
echo $TIME
echo ""
echo -e "[\e[33mPENDING\e[0m] Updating repositories..."

apt update > /dev/null 2>&1

echo -e "\033[1A\033[2K[\e[32mOK\e[0m] Updated repositories"

TOTAL=$(($(apt list --installed 2>/dev/null | wc -l)-1))
UPGRADABLE=$(($(apt list --upgradable 2>/dev/null | wc -l)-1))

if [[ $UPGRADABLE -le 0 ]]; then
    echo -e "  - \e[1m$TOTAL\e[0m packages installed, \e[1mnone\e[0m to be upgraded"
    echo -e "[\e[32mOK\e[0m] Up to date"
    curl -u "$SECRET" -d "Repositories updated, system already up to date" "$URL" > /dev/null 2>&1
else
    echo -e "  - \e[1m$TOTAL\e[0m packages installed, \e[1m$UPGRADABLE\e[0m to be upgraded"
    echo -e "[\e[33mPENDING\e[0m] Upgrading packages..."

    apt upgrade -y > /dev/null 2>&1

    echo -e "\033[1A\033[2K[\e[32mOK\e[0m] Upgraded packages"

    STILL_UPGRADABLE=$(($(apt list --upgradable 2>/dev/null | wc -l)-1))
    UPGRADED=$(($UPGRADABLE-$STILL_UPGRADABLE))

    echo -e "  - \e[1m$UPGRADED\e[0m package(s) upgraded, \e[1m$STILL_UPGRADABLE\e[0m held due to phasing"
    echo -e "[\e[32mOK\e[0m] Up to date"

    METHOD="manually"
    if [[ "$2" == "-s" ]]; then
        METHOD="automatically"
    fi
    MESSAGE="Upgraded $UPGRADED package(s) $METHOD, $STILL_UPGRADABLE held due to phasing"

    if [[ "$1" == "-c" ]]; then
        echo ""
        echo -e "[\e[33mPENDING\e[0m] Cleaning up..."
        apt autoremove -y > /dev/null 2>&1
        apt clean > /dev/null 2>&1
        echo -e "\033[1A\033[2K[\e[32mOK\e[0m] Cleaned up"
        NEW_TOTAL=$(($(apt list --installed 2>/dev/null | wc -l)-1))
        echo -e "  - \e[1m$(($TOTAL-$NEW_TOTAL))\e[0m package(s) removed"
        echo -e "[\e[32mOK\e[0m] All done"
        MESSAGE="$MESSAGE, removed $(($TOTAL-$NEW_TOTAL)) packages"
    fi
    curl -u "$SECRET" -d "$MESSAGE" "$URL" > /dev/null 2>&1
fi
