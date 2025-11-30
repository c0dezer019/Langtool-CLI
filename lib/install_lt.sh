#!/bin/bash

fetch_lt_versions() {
    local versions

    # Fetch snapshots page and extract date versions (YYYYMMDD format)
    # Looking for lines like: LanguageTool-20251121-snapshot.zip
    # Excluding wikipedia and predeploy variants
    versions=$(curl -s "https://internal1.languagetool.org/snapshots/" | \
               grep -oP 'LanguageTool-\K[0-9]{8}(?=-snapshot\.zip)' | \
               grep -v 'wikipedia\|predeploy' | \
               sort -r | \
               uniq | \
               head -20)

    if [[ -z "$versions" ]]; then
        echo "Failed to fetch versions from snapshots page. Using default." >&2
        # Fallback to default
        echo "latest"
    else
        echo "$versions"
    fi
}

