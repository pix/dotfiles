## README.md for Chezmoi Repository

Welcome to my Chezmoi repo!

### Managed Files
This repository cleverly organizes files into various categories, adapting to your needs:

**Security Tools and Configurations:**
- Conditional deployment of pentesting tools like [Burp](dot_bin/executable_burp), [SecLists](.chezmoiexternals/pwning.yaml.tmpl) based on config flags.
- Dynamic font management and GUI elements depending on the chosen OS and user preferences, managing files like [fonts](.chezmoiexternals/fonts.yaml.tmpl) and [font configurations](dot_config/fontconfig).

**Ephemeral Configurations:**
- Minimal configurations, ideal for testing environments, including conditional management of [shells and tools](dot_config/shells).

### Dynamic Data Handling with Templates

There's a way to allow templates to be used in [`.chezmoidata`](.chezmoidata) in a way.
By placing templates under [`.chezmoitemplates/data/`](.chezmoitemplates/data/) and merging them into [`.chezmoi.yaml.tmpl`](.chezmoi.yaml.tmpl) , the system allows for dynamic configuration management. This method was indirectly inspired by a community request for enhanced templating capabilities in Chezmoi, specifically for the [`.chezmoidata`](.chezmoidata) file to support templates. Though the request was not implemented directly into Chezmoi, this setup provides a flexible workaround.

To replicate this in your own repository, simply add your templated configurations under the [`.chezmoitemplates/data/`](.chezmoitemplates/data/) directory and ensure they are properly referenced in your main [`.chezmoi.yaml.tmpl`](.chezmoi.yaml.tmpl). This method enhances the dynamic generation of configurations, making your system management both efficient and scalable.

For a detailed exploration of the feature request that inspired this workaround, check out [GitHub issue #1663](https://github.com/twpayne/chezmoi/issues/1663).

Happy configuring!

<!-- begin dotfiles-doc --markdown -->
## Available commands and functions



### DEVEL

- **Command**: `delta`
  - A syntax-highlighting pager for git, diff, grep, and blame output
- **Command**: `git-ignore`
  - Manage and add entries to .gitignore files
- **Command**: `mise`
  - Use mise to manage your development environments (toolchains, SDKs, etc.)
- **Command**: `showcert`
  - Show or save the certificate of a remote server

    >       Usage: showcert [-s|-r] <cert-source> [port]
    >         -s: Show certificate information (default)
    >         -r: Save the root certificate

### DOCKER

- **Command**: `docker-buildx`
  - Use docker-buildx to help build docker images
- **Function**: `da`
  - Attach to a running container with fzf.
- **Function**: `dcrun`
  - Run a container (with docker-compose support)

    >         $ dcrun "php" "latest" "php" "-v"
- **Function**: `di`
  - Exec into a running container with fzf.
- **Function**: `dlog`
  - Show logs of a running container with fzf.
- **Function**: `docker-print`
  - Print docker containers, images, volumes and networks.
- **Function**: `docker-run`
  - Run a container with docker or docker-compose.

    >         function docker-php() { docker-run "php" "latest" "php" "$@"; }
- **Function**: `drun`
  - Run a container with docker.

    >         $ drun "php" "latest" "php" "-v"

### FIREFOX

- **Binding**: `Ctrl+,`
  - Switch to a tab in Firefox using rofi selector

### HYPRLAND

- **Binding**: `Alt+"`
  - Change window opacity to preset 3 (default 0.7)
- **Binding**: `Alt+&`
  - Change window opacity to preset 1 (default 0.9)
- **Binding**: `Alt+F4`
  - Close the active window
- **Binding**: `Alt+Tab`
  - Cycle through tabbed windows
- **Binding**: `Alt+²`
  - Cycle through windows (regular, floating, tabbed)
- **Binding**: `Alt+é`
  - Change window opacity to preset 2 (default 0.8)
- **Binding**: `Super+D`
  - Open rofi menu for launching applications
- **Binding**: `Super+Escape`
  - Escape any special workspace
- **Binding**: `Super+F`
  - Toggle floating mode for the active window
- **Binding**: `Super+I`
  - Open a rofi menu for changing the wallpaper
- **Binding**: `Super+K`
  - Show keeppassxc workspace
- **Binding**: `Super+L`
  - Lock the screen
- **Binding**: `Super+Return`
  - Open a terminal
- **Binding**: `Super+S`
  - Toggle the magic workspace
- **Binding**: `Super+Shift+F`
  - Toggle fullscreen mode for the active window
- **Binding**: `Super+Shift+P`
  - Open a color picker and copy the color to the clipboard
- **Binding**: `Super+Shift+T`
  - Move the active window out of the tabbed group
- **Binding**: `Super+T`
  - Toggle tabbed mode for the active window
- **Binding**: `Super+V`
  - Open a clipboard manager
- **Binding**: `Super+Z`
  - Move the active window from/to the magic workspace
- **Binding**: `²`
  - Switch to terminal workspace
- **Command**: `hyprlock-status`
  - Render the lower status bar for hyprlock
- **Function**: `windowrulev2`
  - Capture the class and title of the currently focused window and copy it to the clipboard.

### KITTY

- **Binding**: `Ctrl+Shift+Down`
  - Create a new tab
- **Binding**: `Ctrl+Shift+G`
  - Open the result of the previous command in nvim in a new tab
- **Binding**: `Ctrl+Shift+H`
  - Open the result of the scrollback buffer in nvim in a new tab
- **Binding**: `Ctrl+Shift+Minus`
  - Decrease the font size
- **Binding**: `Ctrl+Shift+MouseRight`
  - Open the result of the selected command in nvim in a new tab
- **Binding**: `Ctrl+Shift+Plus`
  - Increase the font size
- **Binding**: `F1`
  - Create a new tab with the current working directory (works with kitty's ssh integration too)

### MISC

- **Command**: `dotfiles-doc`
  - Search and display doc tags in chezmoi managed files
- **Command**: `font-selector`
  - Select a font and preview it in various widgets
- **Command**: `rofi-abitbol`
  - Display the script of the movie "La Classe Américaine" in rofi and copy the selected line to the clipboard
- **Command**: `ssh-serve-files`
  - Serve files over SSH using python3 http.server

### NVIM

- **Binding**: `Ctrl+v Ctrl+v`
  - Display the buffer selection menu

### PWNING

- **Command**: `burp`
  - Manage and run Burp Suite with Jython and JRuby, with the ability to patch missing extensions in Burp Suite

    >       See chezmoidata/burp.yaml for the list of extensions
- **Command**: `gitleaks`
  - Gitleaks is a SAST tool for detecting and preventing hardcoded secrets like passwords, api keys, and tokens in git repos.
- **Command**: `grep-it.sh`
  - Use good old grep to find security and privacy related stuff in code.
- **Command**: `trufflehog`
  - Find leaked credentials in git, github, gitlab, docker, s3, filesystem (files and directories), etc.
- **Command**: `uber-apk-signer`
  - Sign and align APK files (Android application packages) with the Uber Apk Signer tool

### SHELL

- **Command**: `age`
  - A simple, modern and secure encryption tool with small explicit keys, no config options, and UNIX-style composability
- **Command**: `age-keygen`
  - Generate age keys
- **Command**: `bat`
  - Syntax highlighting for cat

    >       https://github.com/sharkdp/bat
- **Command**: `battery-status`
  - Print the battery status of your laptop
- **Command**: `btop`
  - Resource monitor that shows usage and stats for processor, memory, disks, network and processes
- **Command**: `cht.sh`
  - cht.sh is a community driven cheat sheet for developers
- **Command**: `dasel`
  - Query and modify data structures from the command line (yq/jq alternative)
- **Command**: `direnv`
  - Load environment variables from .envrc files, use `direnv allow` to allow a .envrc file to be loaded.
- **Command**: `eza`
  - Community-driven, ls replacement with advanced features
- **Command**: `fd`
  - Simple, fast and user-friendly alternative to find
- **Command**: `fd-preview`
  - Preview files and directories with fd, bat and eza
- **Command**: `fzf`
  - Command-line fuzzy finder
- **Command**: `gdu`
  - Disk usage analyzer with console interface
- **Command**: `glow`
  - Render markdown on the terminal
- **Command**: `lazydocker`
  - Simple terminal UI for interacting with Docker
- **Command**: `lazysql`
  - Simple terminal UI for interacting with SQL databases
- **Command**: `rg`
  - ripgrep combines the usability of The Silver Searcher with the raw speed of grep
- **Command**: `tldr`
  - Simplified and community-driven man pages
- **Command**: `trivy`
  - Trivy is a simple and comprehensive vulnerability scanner for containers and other artifacts
- **Command**: `yazi`
  - Yazi is a simple tui file manager written in rust

    >       https://github.com/sxyazi/yazi
- **Function**: `concat-files`
  - Concatenate all files in the current directory using fd.

    >       Uses .dockerignore and .openaiignore to exclude files.
- **Function**: `ermine_pro`
  - Static binary compilation with Magic Ermine Pro.

    >       Usage: ermine_pro <source> [destination] [arch]
- **Function**: `ermine_x64`
  - Static binary compilation with Magic Ermine Pro for x64.

    >       Usage: ermine_x64 <source> [destination]
- **Function**: `ermine_x86`
  - Static binary compilation with Magic Ermine Pro for i386.

    >       Usage: ermine_x86 <source> [destination]
- **Function**: `fuzzy-sys`
  - Utility for using systemctl interactively via fzf.
- **Function**: `fz`
  - Search for a file with fzf and open it in vim.
- **Function**: `fzd`
  - Change directory with fzf.
- **Function**: `fzg`
  - Search for a string in files with fzf.
- **Function**: `fzjq`
  - Interactive jq filtering. (alt-c: copy to clipboard)
- **Function**: `fzman`
  - Show a man (alt-m), tldr (alt-t) or cheat (alt-c) page in fzf.
- **Function**: `mkcd`
  - Create a directory and change into it.
- **Function**: `sanitize-perms`
  - Sanitize permissions and ownership of files and directories.

### TMUX

- **Binding**: `Ctrl+B Ctrl+B`
  - Display the window selection menu.

### VSCODE

- **Binding**: `Ctrl+,`
  - Display the file list menu (like Ctrl+P, mimic firefox's Ctrl+,)
- **Command**: `code-wait`
  - Run Visual Studio Code with the specified files and wait for it to close

### ZSH

- **Binding**: `Alt-C`
  - Change directory with fzf.
- **Binding**: `Alt-K`
  - Run help for the current command.
- **Binding**: `Alt-R`
  - Delete history entries with fzf.
- **Binding**: `Ctrl-F`
  - Edit the current command line in neovim.
- **Binding**: `Ctrl-H`
  - Show fzf-man widget.
- **Binding**: `Ctrl-J`
  - Push the current command onto a stack.
- **Binding**: `Ctrl-R`
  - Search history with fzf.
- **Binding**: `Ctrl-T`
  - Paste the selected file path(s) into the command line.
- **Binding**: `Typing+Down-Arrow`
  - Begin typing a command and press the Down Arrow key to search through your command history backward.
- **Binding**: `Typing+Up-Arrow`
  - Begin typing a command and press the Up Arrow key to search through your command history.
- **Function**: `show-bindings`
  - Show current key bindings for a given type (ctrl (default), alt, ctrl-alt)
