grep resource main.tf | awk -F\" '{printf "%s %s\n",tolower($2),$4}' | awk '{printf "\n\noutput \"%s\" \{\n  value = \"\$\{%s.%s.id\}\"\n\}",tolower($2),$1,$2}' 
