#!/bin/bash

# Set the domain
domain="att.com"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create necessary directories
mkdir -p ~/targets/$domain/recon
cd ~/targets/$domain/recon

# Remove separate files
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Removing separate files..."
echo -e "${BLUE}-----------------------------------------${NC}"
touch "test.txt"
rm -rf *

# Download and unzip the subdomains file from chaos
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Downloading and unzipping the subdomains file from chaos..."
echo -e "${BLUE}-----------------------------------------${NC}"
wget "https://chaos-data.projectdiscovery.io/at&t.zip"
unzip at\&t.zip
rm at\&t.zip

# Run assetfinder
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Running assetfinder..."
echo -e "${BLUE}-----------------------------------------${NC}"
assetfinder -subs-only $domain | grep $domain > assetfinder.txt

# Get subdomains from crt.sh
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Getting subdomains from crt.sh..."
echo -e "${BLUE}-----------------------------------------${NC}"
curl -s 'https://crt.sh/?q=%.'$domain'&output=json' | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > crt.txt

# Run Subfinder recursively
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Running Subfinder recursively..."
echo -e "${BLUE}-----------------------------------------${NC}"
subfinder -d $domain -silent -all -recursive -t 200 -silent -o subfinder-rescursive.txt

# Run Findomain
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Running Findomain..."
echo -e "${BLUE}-----------------------------------------${NC}"
findomain --quiet -t $domain > findomain.txt

# Run Spyhunt
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Running Spyhunt..."
echo -e "${BLUE}-----------------------------------------${NC}"
python3 ~/tools/spyhunt/spyhunt.py -s $domain -sv spyhunt.txt

# # Run bbot
# echo -e "${BLUE}-----------------------------------------"
# echo -e "${GREEN}Running bbot..."
# echo -e "${BLUE}-----------------------------------------${NC}"
# printf '\n%.0s' {1..3} | bbot -t $domain -f subdomain-enum -o .

# Merge all subdomains into all.txt
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Merging all subdomains into all.txt..."
echo -e "${BLUE}-----------------------------------------${NC}"
cat *.txt */subdomains.txt | sort -u > ../all.txt

# # new subdomains
# echo -e "${BLUE}-----------------------------------------"
# echo -e "${GREEN}New subdomains found..."
# echo -e "${BLUE}-----------------------------------------${NC}"
# cat ../all.txt | anew ../new-subdomains.txt | tee ../new.txt

# Extracting important subdomains
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Extracting important subdomains..."
echo -e "${BLUE}-----------------------------------------${NC}"
cd ..
python3 ~/tools/spyhunt/spyhunt.py -isubs new.txt

# Running HTTPX
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Running httpx on all.txt..."
echo -e "${BLUE}-----------------------------------------${NC}"
cat all.txt | httpx -sc -title -cl -probe | grep -v "FAILED" | anew juicy-live.txt
cat juicy-live.txt | sed 's|^[^/]*//||' | cut -d '/' -f 1 | cut -d " " -f 1 > new.txt 

# Port Scan
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Running Port Scan..."
echo -e "${BLUE}-----------------------------------------${NC}"
naabu -l new.txt -o ports.txt

# Running Nuclei
echo -e "${BLUE}-----------------------------------------"
echo -e "${GREEN}Running nuclei scan..."
echo -e "${BLUE}-----------------------------------------${NC}"
nuclei -l new.txt -es info,low | tee vulns.txt

echo -e "${BLUE}-----------------------------------------"
echo -e "${YELLOW}Reconnaissance completed for $domain"
echo -e "${BLUE}-----------------------------------------${NC}"
