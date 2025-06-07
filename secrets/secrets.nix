let
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEK3SEj9kWSBY8FBtlqzIyHh4rFXJFAoNT7opoYgwTP";
in
  {
    "secrets.age".publicKeys = [user];
  }
