# nginx-rotate-app

A lightweight Docker container that serves three HTML pages in rotation using nginx, cycling through them every 5 seconds.

---

## How It Works

A bash script (`rotate_pages.sh`) runs in the background alongside nginx. Every 5 seconds, it updates a symlink at `/usr/share/nginx/html/index.html` to point to the next page in the sequence. Each HTML page also includes a `<meta http-equiv="refresh" content="5">` tag so the browser reloads automatically, keeping the display in sync with the rotation.

---

## Project Structure

```
nginx-rotate-app/
├── docker-compose.yml
├── Dockerfile
├── start.sh
└── webpages/
    ├── index1.html       # Light blue background
    ├── index2.html       # Light green background
    ├── index3.html       # Light coral background
    └── rotate_pages.sh   # Rotation logic
```

---

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

---

## Getting Started

**Build and run:**

```bash
docker compose up --build
```

**Open in your browser:**

```
http://localhost
```

You should see the page background and title change every 5 seconds, cycling through Page 1 → Page 2 → Page 3 → repeat.

**Stop the container:**

```bash
docker compose down
```

---

## Configuration

| Parameter | Location | Default | Description |
|---|---|---|---|
| Rotation interval | `rotate_pages.sh` | `5s` | Time each page is displayed |
| Total rotation duration | `rotate_pages.sh` | `300s` | How long the script runs |
| Exposed port | `docker-compose.yml` | `80` | Host port mapped to nginx |

To change the rotation interval, edit the `INTERVAL` variable in `webpages/rotate_pages.sh`:

```bash
INTERVAL=5   # seconds per page
DURATION=300 # total runtime in seconds
```

---

## Adding More Pages

1. Create a new HTML file in `webpages/`, e.g. `index4.html`
2. Add it to the `PAGES` array in `rotate_pages.sh`:

```bash
PAGES=("index1.html" "index2.html" "index3.html" "index4.html")
```

3. Rebuild the container:

```bash
docker compose up --build
```

---

## Notes

- `start.sh` launches `rotate_pages.sh` in the background and then starts nginx in the foreground, keeping the container alive.
- The rotation script uses a symlink (`ln -sf`) rather than copying files, so page switches are instantaneous with no file I/O overhead.
- After `DURATION` seconds, the rotation script exits, but nginx continues serving whichever page was last active.