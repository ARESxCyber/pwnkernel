import os
import gzip
import base64
import time

os.environ["PWNLIB_NOTERM"] = "true"
import pwn

"""
Example client to send a pre-compiled exploit to the server.
"""


def chunks(xs, n):
    for i in range(0, len(xs), n):
        yield xs[i : i + n]


def send_file(io, filename):
    s = open(filename, "rb").read()
    s = gzip.compress(s)
    s = base64.b64encode(s).decode()

    print(f"Sending {filename}")
    for i, chunk in enumerate(chunks(s, 128)):
        io.sendline(f"echo -n {chunk} | base64 -d > {i:04}.part")
        print(".", end="", flush=True)
    print()

    io.sendline(f"cat * > {filename}.gz")
    io.sendline(f"gzip -d {filename}.gz")
    io.sendline("rm *.part")


io = pwn.remote("35.224.45.136", 1001)

pwn.context.log_level = "debug"
io.recvuntil("$")
pwn.context.log_level = "info"

send_file(io, "solve")
io.sendline("chmod +x solve")
io.interactive()
