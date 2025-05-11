#!/bin/bash

# --- Welcome Message ---
echo "Welcome To Mek's GitHub Clone Script."
echo "This script was developed for mass cloning of"
echo "multiple repositories to a target destination."

# --- Get Target Directory ---
while true; do
    read -rp $'\nEnter Target Directory: ' target_dir

    if [[ -d "$target_dir" ]]; then
        break
    fi

    echo -e "":
    
    read -p "Target Directory: '$target_dir' Does Not Exist. Would You Like To Create It? (Y/N)" createTargetDir

    case "$createTargetDir" in
      [Yy]*) mkdir "$target_dir"; break;;
      [Nn]*) break;;
      *) echo -e "Invalid Option. Try Again";;
    esac
done

# --- Gather GitHub URLs ---
declare -a target_urls

while true; do
    read -rp "Enter GitHub URL To Clone or -1 To Exit: " target_url

    if [[ "$target_url" == "-1" ]]; then
        break
    fi

    target_urls+=("$target_url")
done

# --- Clone Repositories ---
if [[ ${#target_urls[@]} -eq 0 ]]; then
    echo "No URLs provided. Exiting."
    exit 1
fi

for url in "${target_urls[@]}"; do
    echo -e "\nCloning '$url' into '$target_dir'..."

    git clone "$url" "$target_dir/$(basename "$url" .git)"

    if [[ $? -ne 0 ]]; then
        echo "Failed to clone '$url'. Continuing with next..."
    else
        echo "Successfully cloned '$url'."
    fi
done

echo -e "\nAll cloning operations complete."
