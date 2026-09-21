# Dockerfile

Grammar for Dockerfiles: FROM with stages and names, RUN/CMD/ENTRYPOINT with shell or exec form, ENV/ARG/LABEL/COPY/ADD/EXPOSE/VOLUME/USER/WORKDIR and build-stage references.

## Syntax sketch

```
FROM image:tag AS stage
COPY --from=stage /src /dst
```

## AST validation goals

- COPY --from stage references exist
- Single CMD/ENTRYPOINT (last wins, earlier flagged)
- Base image after FROM only
- ARG used before defined flagged
- ENV/ARG key uniqueness
- EXPOSE port range

Implements issue #44.

## Coverage completion

Completes coverage with COPY --chown/--chmod, ADD with checksum and git URLs, RUN heredocs, LABEL metadata, and build-kit secrets.
