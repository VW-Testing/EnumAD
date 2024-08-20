#!/bin/bash

# Create a directory to store your repositories
mkdir -p ~/RFS
cd ~/RFS

sudo apt update -y
sudo apt install -y netexec nuclei python3.11-venv git unzip curl certipy-ad
pip install sectools
git clone https://github.com/VW-Testing/Scanner.git
git clone https://github.com/p0dalirius/Coercer.git
git clone https://github.com/Yaxxine7/ASRepCatcher.git
git clone https://github.com/ly4k/Certipy.git
git clone https://github.com/floesen/EventLogCrasher.git
