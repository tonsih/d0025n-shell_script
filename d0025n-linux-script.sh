#!/bin/sh

# Exit handler function
exit_handler() {
    echo "Exiting..."
}

# Trap EXIT signal to call the exit handler
trap exit_handler EXIT

# Function to validate file input
file_validation() {
    if [ -z "$1" ]; then
        echo "Please provide a file name as an argument."
        exit 1
    fi

    if [ ! -f "$1" ] || [ ! -r "$1" ]; then
        echo "The file does not exist or cannot be read."
        exit 1
    fi
}

# Main play function
play() {
    # Function to list courses from a file
    list_courses() {
        counter=1
        while IFS= read -r course; do
            echo "$counter. $course"
            courses+=("$course")
            counter=$((counter + 1))
        done < "$1"
    }

    # Main game logic
    main_game() {
        clear
        echo -e "What is your name?"
        read -r user_name
        clear
        echo -e "Welcome $user_name!\n"
        
        while true; do
            list_courses "$1"

            echo -e "\nFor which course is this assignment for? (Press x to exit)"
            read -r course_input

            if [[ $course_input == "x" || $course_input == "X" ]]; then
                exit 1
            fi

            clear

            if [[ "$course_input" =~ ^[0-9]+$ ]] && 
               (( course_input >= 1 && course_input <= ${#courses[@]} )); then
                index=$((course_input - 1))
                chosen_course=${courses[index]}

                case $chosen_course in
                    "D0025N")
                        echo "Good job!"
                        break
                        ;;
                    "I0015N")
                        echo -e "This course was cool, but is not the course for this assignment.\n"
                        ;;
                    *)
                        echo -e "$chosen_course is the wrong course. Try again...\n"
                        ;;
                esac
            else
                echo -e "Invalid input. Please enter a number between 1 and ${#courses[@]}.\n"
            fi
        done
    }

    # Start the main game
    main_game "$1"
}

# Main function to start the script
main() {
    file_validation "$1"
    play "$1"
}

# Execute the main function with the provided argument
main "$1"
