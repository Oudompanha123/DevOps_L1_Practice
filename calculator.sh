#!/usr/bin/env bash
# Simple calculator with functions for add, subtract, multiply, divide, power.
# Uses awk for math so decimals work (and it runs in Git Bash, which has no bc).

# Check that a value is a number (integer or decimal, optional minus sign)
is_number() {
    [[ "$1" =~ ^-?[0-9]+([.][0-9]+)?$ ]]
}

add() {
    awk -v a="$1" -v b="$2" 'BEGIN { print a + b }'
}

subtract() {
    awk -v a="$1" -v b="$2" 'BEGIN { print a - b }'
}

multiply() {
    awk -v a="$1" -v b="$2" 'BEGIN { print a * b }'
}

divide() {
    if awk -v b="$2" 'BEGIN { exit !(b == 0) }'; then
        echo "Error: cannot divide by zero" >&2
        return 1
    fi
    awk -v a="$1" -v b="$2" 'BEGIN { print a / b }'
}

power() {
    awk -v a="$1" -v b="$2" 'BEGIN { print a ^ b }'
}

# ---------- Menu ----------
while true; do
    echo
    echo "===== Calculator ====="
    echo "1. Add"
    echo "2. Subtract"
    echo "3. Multiply"
    echo "4. Divide"
    echo "5. Power"
    echo "6. Exit"
    read -rp "Choose an option (1-6): " choice || break

    if [[ "$choice" == "6" ]]; then
        echo "Goodbye!"
        break
    fi

    if [[ ! "$choice" =~ ^[1-5]$ ]]; then
        echo "Invalid option, please choose 1-6."
        continue
    fi

    read -rp "Enter first number: " num1
    read -rp "Enter second number: " num2

    if ! is_number "$num1" || ! is_number "$num2"; then
        echo "Error: please enter valid numbers."
        continue
    fi

    case "$choice" in
        1) echo "Result: $num1 + $num2 = $(add "$num1" "$num2")" ;;
        2) echo "Result: $num1 - $num2 = $(subtract "$num1" "$num2")" ;;
        3) echo "Result: $num1 * $num2 = $(multiply "$num1" "$num2")" ;;
        4) result=$(divide "$num1" "$num2") && echo "Result: $num1 / $num2 = $result" ;;
        5) echo "Result: $num1 ^ $num2 = $(power "$num1" "$num2")" ;;
    esac
done
