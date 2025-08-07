FROM debian:12

RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    python3-pip \
    python3-apt \
    systemctl \
    sudo

WORKDIR /test

COPY . .

RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install ansible

RUN echo "[audio_receivers]" > inventory && \
    echo "localhost ansible_connection=local ansible_become=yes" >> inventory

CMD . venv/bin/activate && \
    ansible-galaxy role install -r requirements.yml && \
    ansible-playbook --syntax-check main.yml && \
    ansible-playbook --check -i inventory main.yml
