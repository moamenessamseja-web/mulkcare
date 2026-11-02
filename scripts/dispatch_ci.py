import urllib.request, json
REPO = "moamenessamseja-web/mulkcare"
GH_TOKEN = open('/tmp/gh_token.txt').read().strip()
url = f"https://api.github.com/repos/{REPO}/actions/workflows/build-apk.yml/dispatches"
data = json.dumps({"ref": "feature/flutter-migration-complete"}).encode()
req = urllib.request.Request(url, data=data, headers={
    "Authorization": f"token {GH_TOKEN}",
    "Accept": "application/vnd.github+json",
    "X-GitHub-Api-Version": "2022-11-28",
    "User-Agent": "Python"
})
try:
    with urllib.request.urlopen(req) as r:
        print("HTTP", r.status)
        d = json.loads(r.read().decode())
        print("run_id:", d["id"])
        print("html_url:", d["html_url"])
except urllib.error.HTTPError as e:
    print("HTTP", e.code)
    print(e.read().decode())
