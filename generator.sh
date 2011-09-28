#!/bin/bash

make_input_files() {

# Make sure you have a list of kml files:
for i in $@; do

    if [[ "$i" =~ .*.kml ]]; then
        grep '<name>.*km/h' $i|cut -d\~ -f2|tr -d ' '|sed 's/km\/h//' > ${i/.*.kml/.input}

    else
        echo "Error, only .kml files allowed"
        exit 1
    fi
done
}

make_color_codes() {

# Generate all possible outputs:
for i in $@; do

    if [[ "$i" =~ .*.input ]]; then
        ./main.py $i
        mv ${i/input/colorCodes} ${i/input/colorCodes.local}

    else
        echo "Error, only .input files allowed"
        exit 1
    fi
done

# Now make the global values if there is more than one entry:
if (( ${#@} > 1 )); then
    ./main.py $@
fi

}


# The program must receive .kml files as command line arguments. Otherwise it
# will exit with error
make_input_files $@
make_color_codes ${@/.*.kml/.input}
