# WellDone
A social media that promotes appreciation.

## Getting Started

### Prerequisites
Ensure you have the following installed:
- [Docker](https://www.docker.com/get-started)
- [Git](https://git-scm.com/)

### Clone the Repository

To get started, clone the repository:

```bash
git clone https://github.com/sme-wtag/well-done.git
cd well-done
```
### Start Up the Docker Containers

Once inside the project root directory, start up the Docker containers:

```bash
docker-compose up --build
```

### Additional Lucee Server Configuration

1.  Open Lucee Admin:

    1.  Go to the Lucee Admin panel by navigating to http://localhost:8888/lucee/admin/server.cfm. \
    Enter "admin" as the Password

2.  Set Up Data Sources:

    1.Navigate to **Services -> Datasource**. \
    Create a new datasource with the following details:
    1.  **Name:** `heart_nest`
    2.  **Database:** `MySQL`

    Press `create`

    2.Configure the following settings: 
    1.  **Name:** `heart_nest` 
    2.  **Host:** `host.docker.internal`
    3.  **Port:** `3306`
    4.  **Username:** `mehrab`
    4.  **Password:** `pokPOK123`

    Press `create`

3.  Set Up REST Mappings

    1.Navigate to **Archives & Resources -> Rest**. \
    Create new mapping with the following details:
    1.  **Virtual:** `/api`
    2.  **Physical:** `/var/www/api`

    Press `save`

4.  Restart
    1.Navigate to **Services -> Restart**. \
    Press `Restart Lucee`


### Running the Project

Enter the following address in your browser:

```http://127.0.0.1:8888/```





