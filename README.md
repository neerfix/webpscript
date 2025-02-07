# WebP Script

`webpg.sh` is a simple bash script that converts images in a directory to WebP format and optionally deletes the original files after conversion. The script also includes an automatic update feature that checks for the latest version of the script from the GitHub repository.

## Features

- Converts all images in the current directory to WebP format.
- Optionally deletes the original files after conversion.
- Automatically checks for updates and installs the latest version.
- Simple command-line interface.

## Installation

### Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/neerfix/webpscript.git
cd webpscript
```

### Run the Installation script
Run the install.sh script to set up the webpg command as an alias:

```bash
sudo ./scripts/install.sh
```

This will copy the webpg.sh script to /usr/local/bin and add an alias webpg to your shell configuration (e.g., .bashrc or .zshrc).

## Usage
Once installed, you can use the webpg command to run the script.

### Convert Images to WebP
To convert all images in the current directory to WebP format:

```bash
webpg
```

### Convert and Delete Original Files
If you want to delete the original files after conversion:

```bash
webpg --deleteOriginalFile
```

Or using the shorthand:

```bash
webpg -dof
```

### Help
To display the help information:

```bash
webpg --help
```

Or:

```bash
webpg -h
```

## Automatic Updates
Every time you run the webpg command, the script will check for the latest version from the GitHub repository. If a new version is found, it will automatically download and install the update.

## Contributing
If you would like to contribute to this project, please fork the repository, create a new branch for your changes, and submit a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
