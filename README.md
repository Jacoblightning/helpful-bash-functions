# helpful-bash-functions
Just a collection of some helpful bash functions I made

# Usage
## In your shell:
To use these functions in your shell. Just source it in your bashrc:

Add the following line to your ~/.bashrc:
```shell
source helpful_bash_functions.sh # Or wherever the script is located
```
## As a dependency:
One way to use this script as a dependency is to download and source the script in your program.

I have written a simple example.

```shell
# This script depends on helpful_bash_functions.
down_to=$(mktemp)
wget -O "$down_to" "https://raw.githubusercontent.com/Jacoblightning/helpful-bash-functions/main/helpful_bash_functions.sh"
source "$down_to"

# Continue script
```