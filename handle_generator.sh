#!/bin/bash

function USER_PROMPT () {
        declare -a WORDS
        read WORD

        while [[ $WORD != ":done" ]]
        do
                local LEADER="${WORD%%\|*}"
                local VARIATION_STR="${WORD#$LEADER}"

                # Update IFS (internal field separator) to match dividers in VARIATION_STR
                IFS="|"
                # Read string into an array, ignoring empty entries
                read -ra VARIATIONS <<< $VARIATION_STR # -ra reads into an array using the current IFS value
                # Remote empty elements from the array (if any)
                local VARIATIONS=("${VARIATIONS[@]:1}")

                echo "Variations string: ${VARIATION_STR}"
                echo "Variations: ${VARIATIONS[@]}"
                echo "Leader: ${LEADER}"

                if [[ ${#VARIATIONS} -gt 0 ]] 
                then
                        for ELEMENT in "${VARIATIONS[@]}"
                        do
                                WORDS+=("${LEADER}${ELEMENT}")
                        done
                else
                        WORDS+=("$WORD")
                fi

                echo -e "\n$WORD Added. WORDS now contains: ${WORDS[@]} \n"
                echo -e "Feel free to add another word!\n" 
                read WORD
        done

        echo -e "\nInput complete. Outputting possible combinations...\n"
        GET_COMBINATIONS "${WORDS[@]}"
}

function GET_COMBINATION () {
        declare -a OUTPUT
        local LEADER=$1

        shift 1 # Shift to skip the first one argument
        local POOL=("$@")

        echo -e "\nLeader: $LEADER\n"

        for FOLLOWER in "${POOL[@]}"
        do
                if [[ $LEADER != $FOLLOWER ]]
                then
                        local COMBO="${LEADER}${FOLLOWER}"
                        # IF combination is not longer than 15 characters
                        if [[ "${#COMBO}" -le 15 ]]
                        then
                                echo "${COMBO}"
                                OUTPUT+=("${COMBO}")
                        fi
                fi
        done

        # Uncomment to print one-liners
        # echo "${OUTPUT[@]}"
}

function GET_COMBINATIONS () {
        local POOL=("$@")

        # For each index of POOL, iterate over every other index, make a string of the combinations
        # with the leader always in front
        for LEADER in "${POOL[@]}"
        do
                GET_COMBINATION ${LEADER} "${POOL[@]}"
        done
}

# Ask user for input
echo -e "Welcome to Handle Generator!\n"
echo -e "Description: Handle Generator generates duo word combinations based on the input words.\n"
echo -e "Instructions: after the prompt, type a word you'd like to compare, and press [ENTER]"
echo -e "Instructions: when you are done, type ':done,' and press [ENTER]\n"
echo -e "Notes: you can pass different variations of the word by using the following format:"
echo -e "observ|e|ing|ed|er|ation\n"
echo -e "This will add the following words to the potential combinations:"
echo -e "observe, observing, observed, observer, observation"
echo -e "\nPlease enter your first word!\n"

USER_PROMPT
