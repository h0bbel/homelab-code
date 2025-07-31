# Portainer Inventory Script

**Version:** 1.2.1  
**Author:** Christian Mohn  
**License:** MIT

## Overview

This script connects to a [Portainer](https://www.portainer.io/) instance and generates a Markdown report containing detailed information about all Docker containers and stacks across every environment (endpoint) managed by Portainer.

The report includes:

- A list of all environments (endpoints)
- Stacks and their metadata (ID, name, type, status)
- Grouped containers per stack, categorized by running or stopped state
- Orphan containers (not part of any stack)
- Metadata for each container (name, image, status, ports, ID, environment, volumes, network)

The output is saved as a `portainer-inventory.md` file. 

[Sample Output](sample-output.md)

---

## Requirements

- `bash` (tested with macOS default Bash 3.2 and later)
- [`jq`](https://stedolan.github.io/jq/) for parsing JSON
- `curl` for API communication with Portainer
- Access to your Portainer API with valid credentials

---

## Setup

1. Clone/download this script to your system.

2. Create a `.env` file in the same directory:

```ini
# Portainer API URL (no trailing slash)
PORTAINER_URL=https://your-portainer.example.com

# Portainer username and password
USERNAME=admin
PASSWORD=your-password

# Use insecure SSL connection (true/false)
# Set to 'true' to allow curl to skip certificate validation (e.g., for self-signed certs)
USE_INSECURE_SSL=true

```

Optinally rename `.env-example` to `.env` and edit with your values.

## Usage

Make the script executable:

``` bash
chmod +x portainer-inventory.sh
```

Run it:

``` bash
./portainer-inventory.sh
```

The generated Markdown report will be saved as:

``` bash
portainer-inventory.md
```

Check version:

``` bash
./portainer-inventory.sh --version
```

### Custom Header (Optional)

If you want to add a custom header at the top of the generated report, create a file named `header.md` in `template` directory.

Example `template/header.md`:

``` markdown
# Internal Infrastructure

This report contains a live snapshot of Docker containers deployed across all environments managed by Portainer.

**Confidential** – For internal use only.
```

## License

This project is licensed under the MIT License. See the [LICENSE](/LICENSE) file for details.
