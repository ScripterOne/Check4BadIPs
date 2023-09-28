# Check4BadIPs
This script is designed to look at active connections via IP address on your computer and compare them against the Bad IP List.  It is a very low grade check as bad actors frequently change IP's these days.
# PowerShell Security Script

## Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Functions](#functions)
6. [Configuration](#configuration)
7. [Logs](#logs)
8. [Contributing](#contributing)
9. [License](#license)
10. [Contact](#contact)

## Overview

This PowerShell Security Script performs three key operations to enhance your network security:

1. **Update Bad IP List**: Downloads and updates a list of known malicious IP addresses.
2. **Generate Net Traffic Report**: Reports on all active UDP and TCP connections.
3. **Check for Bad IPs**: Compares active connections against the bad IP list and warns if any match.

## Requirements

- PowerShell 5.1 or above
- Internet access for updating the bad IP list

## Installation

1. Download the script file and place it in a directory of your choice.
2. Edit the `$directoryPath` variable in the script to specify where you'd like to save your logs and reports.

## Usage

1. Open PowerShell as an Administrator.
2. Navigate to the folder where the script is located.
3. Run the script using `.\script_name.ps1`.
4. Follow the on-screen instructions.

## Functions

### Update-BadIPList

This function downloads a list of malicious IPs from a specified source and updates a local CSV file. The file will only be downloaded if the local copy is older than one hour.

### Generate-NetTrafficReport

This function captures all active UDP and TCP network connections and exports the details to a CSV file.

### Check-BadIPs

This function checks the current network connections against the bad IP list and warns if any matches are found.

## Configuration

You can modify the following variables:

- `$directoryPath`: The directory where all the CSV files and logs will be stored.
- `$badIPListFile`: The name of the CSV file storing the bad IP addresses.
- `$netTrafficReportFile`: The name of the CSV file storing the net traffic report.
- `$logFile`: The name of the text file storing the logs.

## Logs

The script generates a log file that is saved in the same directory as the script. The log will contain:

- The time the script was executed
- Any errors that occurred during execution

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Contact

For any questions, please contact [scripter@everstar.com](mailto:scripter@everstar.com).

---

Generated by [GPT-4](https://openai.com/research/gpt-4) and EverStaR on 9/27/2023.