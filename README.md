# MikroWizard Deployment

This repository provides a full Docker-based setup for deploying MikroWizard services, including **MikroMan** (backend) and **MikroFront** (frontend), along with the necessary database and Redis stack.

---

## Repository Structure

```
├── mikrofront/                # MikroFront service files
├── mikroman/                 # MikroMan service files
├── docker-compose.yml         # Main Docker Compose file
├── init-db.sql                # Database initialization script
├── prepare.sh                 # Script to prepare host machine
├── .env                       # Configuration file for environment variables
```

---

## Prerequisites

1. **Docker**: Ensure Docker is installed on your machine.
   - Installation guide: [Docker Documentation](https://docs.docker.com/get-docker/)
2. **Docker Compose**: Ensure Docker Compose is installed.
   - Installation guide: [Docker Compose Documentation](https://docs.docker.com/compose/install/)

---

## Setup Instructions

### Step 1: Clone the Repository

```bash
git clone https://github.com/MikroWizard/docker-compose-deployment.git mikrowizard
cd mikrowizard
```

### Step 2: Configure Environment Variables

Edit the `.env` file to set the appropriate values for your environment:

```env
DB_NAME=mikrowizard
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=host.docker.internal
SERVER_IP=127.0.0.1
RAD_SECRET=mysecret
```

Ensure you replace `your_password` and other placeholders with actual values.

### Step 3: Prepare Host Machine

Run the `prepare.sh` script to create required directories and files:

```bash
chmod +x prepare.sh
./prepare.sh
```

This script will:

- Create the `conf`, `firmware`, and `backups` folders on the host machine.
- Ensure proper permissions.
- Create the needed configuration Files

### Step 4: Start the Services

Use Docker Compose to build and start the services:

```bash
docker-compose up --build
```

This command will:

- Build the Docker images for MikroMan and MikroFront.
- Start the PostgreSQL database, Redis stack, and MikroWizard services.

### Step 5: Access the Application

- **Frontend**: Open [http://localhost](http://localhost) in your browser.
- **Backend**: Accessible through configured API endpoints.

---

## Database Initialization

1. The database is initialized automatically using the `init-db.sql` script during container startup.
2. Ensure the database extensions and migrations are applied:
   - UUID extension is enabled.
   - `dbmigrate.py` script creates required tables.

---

## Customization

### Environment Variables

All environment variables are centralized in the `.env` file. Update these values to customize your deployment.

### Volume Mapping

Host directories `conf`, `firmware`, and `backups` are mapped to container paths:

- `conf`: Configuration files.
- `firmware`: Stores firmware files.
- `backups`: Stores database and system backups.

---

## Troubleshooting

### Common Issues

1. **Database Connection Errors**:
   - Verify the `DB_HOST` in `.env` points to `host.docker.internal` or the appropriate host.
2. **Permission Denied**:
   - Ensure you have execution permissions for `prepare.sh`.

### Logs

Check logs for debugging:

```bash
docker-compose logs -f
```

---

## Contributions

Contributions are welcome! Submit issues or pull requests to improve the deployment process.

---

## License

This repository is licensed under the MIT License.

---

## Contact

For any inquiries, contact the MikroWizard team at [info@mikrowizard.com](mailto\:info@mikrowizard.com).


