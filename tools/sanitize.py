#!/usr/bin/env python3
"""usage: sanitize.py <base>. Scan the lines added in base..HEAD and those commit messages.

Fails on private IPs, internal host names, local paths, secret shapes and commit trailers other than Signed-off-by.
Extra patterns, one regex per line, load from the file named by $SANITIZE_EXTRA (kept outside the repo).
Patterns are generic on purpose: this file is public, so it names no real host,
and each is written so it does not match its own source line.
A line marked `noqa: sanitize` is skipped.
"""
import codecs
import os
import re
import subprocess
import sys

OCTET = r"\.(?:\d{1,3}|x)"
PATTERNS = [
    ("private IP", re.compile(rf"(?<![\d.])(?:10(?:{OCTET}){{3}}|172\.(?:1[6-9]|2\d|3[01])(?:{OCTET}){{2}}"
                              rf"|192\.168(?:{OCTET}){{2}})(?![\d.]*\d)")),
    ("internal host", re.compile(r"\b[\w-]+\.(?:int|ops|lan|internal|local|home\.arpa)\.[\w-]+\.[a-z]{2,}\b"
                                 r"|\b[\w-]+\.(?:lan|internal|home\.arpa)\b", re.I)),
    ("local path", re.compile(r"(?<![\w.])(?:/Users/(?!<)[\w.-]+/|/home/(?!<)[\w.-]+/|~/Develop(?:ment)\b"
                              r"|/private/(?:tmp|var/folders)/)")),
    ("private key", re.compile(r"-----BEGIN (?:[A-Z]+ )*PRIVATE KEY-----")),
    ("token shape", re.compile(r"\b(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_\w{30,}|AKIA[0-9A-Z]{16}"
                               r"|xox[abprs]-[\w-]{10,}|sk-[A-Za-z0-9_-]{20,}|glpat-[\w-]{20,})\b")),
    ("secret assignment", re.compile(r"(?i)\b(?:password|passwd|secret|token|api[_-]?key)\b\s*[:=]\s*"
                                     r"['\"]?[A-Za-z0-9+/_.-]{12,}")),
]
SKIP = re.compile(r"noqa: sanitize")
TRAILER = re.compile(r"^(?!Signed-off-by:)[A-Za-z][A-Za-z-]*-[Bb]y:", re.I)
EXTRA = os.environ.get("SANITIZE_EXTRA")
if EXTRA:
    try:
        with open(EXTRA, encoding="utf-8") as fh:
            PATTERNS += [("extra", re.compile(x.strip(), re.I)) for x in fh if x.strip() and not x.startswith("#")]
    except OSError as e:
        sys.exit(f"FAIL sanitize: SANITIZE_EXTRA={EXTRA} unreadable: {e}")


def git(*args):
    # Bytes, then decode: text mode turns a lone \r into a newline and splits the added line.
    return subprocess.run(["git", *args], check=True, capture_output=True).stdout.decode("utf-8", "replace")


def scan(where, text, hits):
    if SKIP.search(text):
        return
    for label, rx in PATTERNS:
        if rx.search(text):
            hits.append(f"FAIL [{label}] {where}")


def unquote(name):
    """Git C-quotes a path with special bytes: "b/a\\tb". Plain paths come back as they are."""
    if not (name.startswith('"') and name.endswith('"')):
        return name
    return codecs.escape_decode(name[1:-1].encode())[0].decode("utf-8", "replace")


def main(argv):
    if len(argv) != 1:
        sys.exit(__doc__)
    base = argv[0]
    try:
        git("rev-parse", "--verify", "-q", f"{base}^{{commit}}")
    except subprocess.CalledProcessError:
        sys.exit(f"FAIL sanitize: base {base} not found, fetch it")
    hits = []
    path, n, added, header = None, 0, 0, False
    diff = git("-c", "core.quotePath=false", "diff", "-U0", "--no-color", "--no-ext-diff", f"{base}...HEAD")
    for line in diff.split("\n"):
        # File headers sit between "diff --git" and the first hunk. Inside a hunk "+++" is content.
        if line.startswith("diff --git "):
            header, path = True, None
        elif header and line.startswith("+++ "):
            path = None if line == "+++ /dev/null" else unquote(line[4:])[2:]
        elif line.startswith("@@"):
            header = False
            m = re.search(r"\+(\d+)", line)
            n = int(m.group(1)) if m else 0
        elif line.startswith("+") and path and not header:
            added += 1
            scan(f"{path}:{n}", line[1:], hits)
            n += 1
    commits = git("rev-list", f"{base}..HEAD").split()
    for c in commits:
        for i, msg_line in enumerate(git("log", "-1", "--format=%B", c).splitlines(), 1):
            scan(f"commit {c[:12]} message line {i}", msg_line, hits)
            if TRAILER.match(msg_line):
                hits.append(f"FAIL [trailer] commit {c[:12]} message line {i}")
    print("\n".join(hits))
    print(f"sanitize: {added} added line(s), {len(commits)} commit message(s) since {base}: "
          + ("FAILED" if hits else "clean"))
    return 1 if hits else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
