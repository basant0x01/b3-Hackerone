#!/bin/bash

# Step 1: Remove duplicates from raw-domains.txt
sort -u raw-domains.txt > domains.txt

# Step 2: Separate wildcard and non-wildcard domains
grep '*.' domains.txt > wildcard-domains.txt
grep -v '*.' domains.txt > single-domains.txt

# Step 3: Remove wildcard symbol from wildcard-domains.txt
sed 's/\*\.//' wildcard-domains.txt > clean-wildcard-domains.txt

# Step 4: Use httprobe to find live-single-domains
cat single-domains.txt | httprobe > live-single-domains.txt

# Step 5: Use findomain to find new subdomains
findomain -f clean-wildcard-domains.txt --http-status -u subdomains.txt.tmp
sort -u subdomains.txt.tmp > subdomains.txt
rm subdomains.txt.tmp

# Step 6: Combine resolved domains and subdomains
cat live-single-domains.txt subdomains.txt > all-subdomains.txt
