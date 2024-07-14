#!/bin/bash

# File containing list of domains
domains_file=$(sort -R $1)

cat "$domains_file"
# 
# # Colors
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# BLUE='\033[0;34m'
# NC='\033[0m' # No Color
# 
# # Check if required tools are installed
# required_tools=("assetfinder" "curl" "jq" "subfinder" "findomain" "httpx" "anew" "gf" "uro" "kxss" "naabu" "nf" "nuclei" "gau" "katana" "notify" "python3")
# for tool in "${required_tools[@]}"; do
#     if ! command -v "$tool" &> /dev/null; then
#         echo -e "${RED}Error: $tool is not installed. Please install it and try again.${NC}"
#         exit 1
#     fi
# done
# 
# # Loop through each domain in the file
# for domain in $domains_file
# do
#     echo -e "${YELLOW}Starting reconnaissance for $domain${NC}"
# 
#     target_dir=/root/targets/$domain/recon
#     ffuf_dir=/root/targets/$domain/discovery
#     mkdir -p "$target_dir"
#     mkdir -p "$ffuf_dir"
#     rm -f "$ffuf_dir/result.txt"
#     cd "$target_dir" || { echo "Failed to change directory to $target_dir"; exit 1; }
# 
#     # Clean up old files
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Removing separate files...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
#     rm -rf *
# 
#     # Run subdomain enumeration tools
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Running assetfinder...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
#     assetfinder -subs-only "$domain" | grep "$domain" > assetfinder.txt || echo -e "${RED}assetfinder timed out or failed${NC}"
# 
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Getting subdomains from crt.sh...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
#     curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > crt.txt || echo -e "${RED}crt.sh timed out or failed${NC}"
# 
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Running subfinder...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
#     subfinder -d "$domain" -all -recursive -t 200 -silent -o subfinder-recursive.txt || echo -e "${RED}subfinder timed out or failed${NC}"
# 
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Running findomain...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
#     findomain -t "$domain" -q > findomain.txt || echo -e "${RED}findomain timed out or failed${NC}"
# 
#     # Merge all subdomains into all.txt
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Merging all subdomains into all.txt...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
#     cat *.txt | sort -u > ../all.txt
# 
#     # Running HTTPX
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Running HTTPX on all.txt...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
#     cd .. || { echo "Failed to change directory"; exit 1; }
#     httpx -t 100 -sc -title -cl -probe -l all.txt | grep -v "FAILED" | tee live.txt
#     cat live.txt | anew juicy-live.txt | sed 's|^[^/]*//||' | cut -d '/' -f 1 | cut -d " " -f 1 > new.txt
# 
#     # Extracting important subdomains
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Extracting important subdomains...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
#     python3 ~/tools/spyhunt/spyhunt.py -isubs new.txt
# 
#     # # Getting Endpoints
#     # echo -e "${BLUE}-----------------------------------------"
#     # echo -e "${GREEN}Getting endpoints...${NC}"
#     # echo -e "${BLUE}-----------------------------------------${NC}"
#     # echo "$domain" | katana -passive -pss waybackarchive,commoncrawl,alienvault -f qurl -o endpoints.txt
#     # gau "$domain" >> endpoints.txt
# 
#     # Checking for XSS
# 
#     # Port Scan
#     # echo -e "${BLUE}-----------------------------------------"
#     # echo -e "${GREEN}Running Port Scan...${NC}"
#     # echo -e "${BLUE}-----------------------------------------${NC}"
#     # naabu -l new.txt -o ports.txt
# 
#     # Nuclei Fuzzer
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Running Nuclei Fuzzer...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
#     nf -d "$domain"
# 
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Checking for XSS...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
#     cat output/*.yaml | gf xss | uro | kxss | grep "<" | tee possible-xss.txt | notify
# 
#     # Running Nuclei
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Running Nuclei scan...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
#     nuclei -l juice_subs.txt -es info,low -rl 15 -t http/exposures/ | tee vulns.txt | notify
# 
#     # Running FFUF
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${GREEN}Running FFUF...${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
# 	for subdomain in $(cat new.txt)
# 	do
# 		ffuf -c -ac -w /root/lists/dirsearch.txt -mc 200 -rate 100 -recursion -r -u "https://$subdomain/FUZZ" >> "$ffuf_dir/result.txt"
# 	done	
# 
#     echo -e "${BLUE}-----------------------------------------"
#     echo -e "${YELLOW}Reconnaissance completed for $domain${NC}"
#     echo -e "${BLUE}-----------------------------------------${NC}"
# 
# done
