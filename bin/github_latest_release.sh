#!/bin/bash
curl -s "https://api.github.com/repos/$1/$2/releases/latest" | jq -r ".assets[] | select(.name | test(\"$3\")) | .browser_download_url"