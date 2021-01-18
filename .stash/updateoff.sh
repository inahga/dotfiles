#!/bin/bash
sudo systemctl stop packagekit.service
sudo systemctl disable packagekit.service
sudo systemctl mask packagekit.service

sudo systemctl stop packagekit-offline-update.service
sudo systemctl disable packagekit-offline-update.service
sudo systemctl mask packagekit-offline-update.service
