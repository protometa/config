
## Generating New Primary Secret Key

Set the home to the primary secret key store

    export GNUPGHOME=/run/media/luke/nixos/home/luke/.gnupg

This may also require `pinentry-program /run/current-system/sw/bin/pinentry-curses`
in `$GNUPGHOME/gpg-agent.conf` followed by `gpgconf --reload gpg-agent`
due to [an issue in `nixos` and `gpg` with `GNUPGHOME` set](https://github.com/NixOS/nixpkgs/issues/72597).

Generate a good passphrase

    xkcdpass

Generate key (encrypted with passphrase above)

    gpg --full-generate-key

Create a `paperkey` backup of your secret key using `lpr` to pipe directly to a printer

    gpg --export-secret-key luke.nimtz@gmail.com | paperkey | lpr

Create a revocation certificate

    gpg --gen-revoke luke.nimtz@gmail.com > ~/.gnupg/revocation.crt

Immediately change the permissions of the revocation

    chmod 600 ~/.gnupg/revocation.crt

In the case that your key is lost or compromised, import this certifcate and send it to the key servers (see below).
Revocation cannot be undone.


## Using Subkeys

Export with only subkey secrets

    gpg --export-secret-subkeys --armor luke.nimtz@gmail.com > ~/.gnupg/secret-subkeys.asc

Unset `GNUPGHOME` and import the subkeys

    gpg --import ~/.gnupg/secret-subkeys.asc

After importing delete `~/.gnupg/secret-subkeys.asc`.

Trust the imported key with

    gpg --edit-key luke.nimtz@gmail.com

and use `trust` command in prompt. Trust the imported key `Ultimately`.

List keys

    gpg --list-keys luke.nimtz@gmail.com
    gpg --list-secret-keys luke.nimtz@gmail.com

Note the pound character by the secret key header (`sec#`). This means the primary secret key is not actually present in this gpg key.

If you are done using the primary secret key you can disconnect the primary secret key storage.

You may change the passphrase of the subkeys to something different than that of the primary secret key store

    gpg --passwd 7D84C97F74C766CB

You can ignore the error regarding the lack of a secret key.

To send the secret subkeys to another host that you control

    gpg --export-secret-subkeys 65A0A84AD59D7EC2A429E4CE7D84C97F74C766CB | ssh luke@192.168.0.1 gpg --import --batch


# Sharing Keys

Export public key for sharing

    gpg --export --armor luke.nimtz@gmail.com > ~/.gnupg/key.asc

Sharing can also be done by sending key to a server

    gpg --send-keys luke.nimtz@gmail.com

Use `--keyserver pgp.mit.edu` to use the MIT server for example.

Search for keys on a server

    gpg --search-keys luke.nimtz@gmail.com

Recieve keys from a server

    gpg --receive-keys luke.nimtz@gmail.com


## Signing Keys

After importing another person's key or recieving it from a server, and after validating the fingerprint is correct,
having been given to you directly in-person with photo ID, sign the key to establish the web of trust.

    gpg --sign-key 65A0A84AD59D7EC2A429E4CE7D84C97F74C766CB

Note you will need access to the primary secret key to sign keys.
The key can then be exported and sent back to the owner so they can make use of your certification.
It is possible but not recommened to send the signed key directly to a server.
Sending the singed key to their email also helps establish validity of their user info email.
Have others sign your key with the same process to establish trust of your key.


## Encryption and Decryption

To encrypt a file called `msg.txt` for a recipient (this can also take multiple recipients)

    gpg --encrypt --recipient luke.nimtz@gmail.com msg.txt

This will output an encrypted file `msg.txt.gpg`

To create text output that can easily be shared use ASCII armore with `--armor`.
This will create an encrypted ASCII text file `msg.txt.asc`.

To encrypt and sign a message

    gpg --encrypt --sign --recipient luke.nimtz@gmail.com msg.txt

Note that you will need access to the primary secret key to sign messages.

To decrypt a message (and verify the signature if present)

    gpg --decrypt msg.txt.gpg


## [Use gpg for ssh](https://opensource.com/article/19/4/gpg-subkeys-ssh)

    gpg --expert --edit-key luke.nimtz@gmail.com

Note you will need access to primary secret key to add sub keys.
Expert mode is required to edit capabilities. In the prompt use command `addkey`. Select `RSA (set your own capabilities)` for kind.
Toggle the allowed actions until only `Authenticate` is selected. Choose a size and expiration.
Default size with no expiration is fine. Save and quit with `save`.

To activate gpg/ssh integration you must have `enableSSHSupport = true;` in nix config, or otherwise
`enable-ssh-support` in `~/.gnupg/gpg-agent.conf` and `export SSH_AUTH_SOCK=(gpgconf --list-dirs agent-ssh-socket)` to enable it manually.

To tell gpg to always use this key, list keygrips
(keygrips refer to a complete key pair, not just the public or private part)

    gpg -k --with-keygrip

and add the keygrip of the new RSA key to `~/.gnupg/sshcontrol`

    echo 7710BA0643CC022B92544181FF2EAC2A290CDC0E >> ~/.gnupg/sshcontrol

Get the public key to add to other servers

    gpg --export-ssh-key luke.nimtz@gmail.com

And it should also now be accessible via the `ssh-agent`

    ssh-add -L

which means you can also use `ssh-copy-id` like normal.

You may have to run

    gpg-connect-agent updatestartuptty /bye

to reset the gpg-ssh integration.

