FROM python:3.6.15-bullseye

RUN useradd -d /runner --uid=1002 runner \
    && echo 'runner:runner' | chpasswd \
    && groupadd docker --gid=999 \
    && usermod -aG docker runner \
    && mkdir /runner \
    && chown -Rf runner:runner /runner \
    && apt update && apt install -y docker docker.io

WORKDIR /runner

COPY entrypoint.sh /runner/

RUN chmod +x /runner/entrypoint.sh && chown -Rf runner:runner /runner

ENV PATH="$PATH:/github/home/.local/bin:/runner/.local/bin:/root/.local/bin"

RUN git clone https://github.com/prefeiturasp/SME-Terceirizadas.git -b development \
    && cd SME-Terceirizadas \
    && pip install --user pipenv \
    && pipenv install --dev \
    && cd .. && rm -Rf SME-Terceirizadas

ENTRYPOINT ["/runner/entrypoint.sh"]
