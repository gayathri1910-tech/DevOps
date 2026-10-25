import http.server
import socketserver
import os

PORT = 8000
directory = "/app"

os.chdir(directory)

Handler = http.server.SimpleHTTPRequestHandler

print(f"Starting web server on port {PORT} to display images...")
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving at http://localhost:{PORT}")
    httpd.serve_forever()