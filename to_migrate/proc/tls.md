# Migration procedure version 0.3

## TLS certificate

### Without a passphrase

The old hoster sends the certificate to the new hoster over a secure channel, as one or more .pem files.

### With a passphrase

The old hoster sends the certificate to the new hoster as one or more .pem files, where the .pem file containing the private key is
encrypted with a passphrase.

The old hoster sends the passphrase over a different and secure medium, in an unrelated message. For instance, if the .pem files were sent via
scp, the passphrase may be sent via PGP-encrypted email.
