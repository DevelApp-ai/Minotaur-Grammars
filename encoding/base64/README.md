# Base64

Minotaur grammar for Base64 and Base64url encodings.

## Syntax sketch

```
SGVsbG8sIHdvcmxkIQ==
aGVsbG8gd29ybGQ
data:text/plain;base64,SGVsbG8=
-----BEGIN PGP MESSAGE-----
```

## AST validation goals

- length of encoded data is a multiple of 4 (with 0-2 padding chars)
- padding only appears at the end of the final chunk
- base64url alphabet has no '+' or '/' and no '=' padding in compact form

## Extended coverage

Adds base64url (RFC 4648 §5), MIME line-wrapping, and data URLs with base64 payloads.

## Coverage completion

Adds RFC 2047 encoded words and OpenPGP ASCII armor framing.
