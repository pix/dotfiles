
# Function to check key bindings
# doc:zfunction:show-bindings:zsh:Show current key bindings for a given type (ctrl (default), alt, ctrl-alt)
show-bindings() {
    local binding_type="$1"
    local prefix=""
    local lower=0

    case "$binding_type" in
        ctrl)
            prefix="^"
            ;;
        alt)
            prefix="^\\["
            lower=1
            ;;
        ctrl-alt)
            prefix="^\\[\\["
            ;;
        help|--help|-h)
            echo "Usage: $0 {ctrl|alt|ctrl-alt}"
            return 1
            ;;
        *)
            # CTRL by default
            prefix="^"
            ;;
    esac

    for key in $(echo azertyuiopqsdfghjklmwxcvbn | sed 's/./& /g'); do
        has_binding=$(bindkey | grep '^"'"$prefix""$(echo $key | tr '[:lower:]' '[:upper:]')"'"')
        echo "$(echo $key | tr '[:lower:]' '[:upper:]'): $has_binding"

        if [ $lower -ne 1 ]; then
            continue
        fi

        has_binding=$(bindkey | grep '^"'"$prefix""$key"'"')
        echo "$key: $has_binding"
    done
}