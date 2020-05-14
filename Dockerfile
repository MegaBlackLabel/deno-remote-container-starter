FROM hayd/deno:ubuntu-1.0.0

EXPOSE 1993

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh /

# ARG USERNAME=deno
# ARG USER_UID=1000
# ARG USER_GID=$USER_UID

# RUN groupadd --gid $USER_GID $USERNAME \
#     && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
#     && apt-get update \
#     && apt-get install -y sudo \
#     && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
#     && chmod 0440 /etc/sudoers.d/$USERNAME /

WORKDIR /app

# Prefer not to run as root.
USER deno

# Cache the dependencies as a layer (this is re-run only when deps.ts is modified).
# Ideally this will download and compile _all_ external files used in main.ts.
# COPY deps.ts /app
# RUN deno cache deps.ts

# These steps will be re-run upon each file change in your working directory:
ADD ./app /app
# Compile the main app so that it doesn't need to be compiled each startup/entry.
# RUN deno run https://deno.land/std/examples/welcome.ts

# These are passed as deno arguments when run with docker:
# CMD ["--allow-net", "main.ts"]

# COPY docker-entrypoint.sh .

ENTRYPOINT ["/docker-entrypoint.sh"]
# SHELL ["/bin/bash", "-l", "-c"]