import os
import gzip
import base64
import time
from pathlib import Path

os.environ["PWNLIB_NOTERM"] = "true"
import pwn

"""
Example client to send a pre-compiled exploit to the server.
"""


def chunks(xs, n):
    for i in range(0, len(xs), n):
        yield xs[i : i + n]


def send_file(io, filepath):
    s = open(filepath, "rb").read()
    s = gzip.compress(s)
    s = base64.b64encode(s).decode()

    print(f"Sending {filepath}")
    for i, chunk in enumerate(chunks(s, 128)):
        io.sendline(f"echo -n {chunk} | base64 -d > {i:04}.part")
        print(".", end="", flush=True)
    print()

    io.sendline(f"cat * > {filepath.name}.gz")
    io.sendline(f"gzip -d {filepath.name}.gz")
    io.sendline("rm *.part")


io = pwn.remote(pwn.args["HOST"], int(pwn.args["PORT"]))

pwn.context.log_level = "debug"
io.recvuntil("$")
pwn.context.log_level = "info"

filepath = Path(pwn.args["EXPLOIT"])
send_file(io, filepath)
io.sendline(f"chmod +x {filepath.name}")
io.interactive()
