
docker_boostraper_run:
  cmd.run:
    - name: curl -sSL get.docker.com | sh && sudo usermod pi -aG docker && newgrp docker > /root/docker-output.log
    - creates: /root/docker-output.log
    # - name: /root/get-docker.sh
    # - skip_verify: True

# docker_boostraper_run:
#   cmd.run:
#     - name: sh /root/get-docker.sh


    # sudo usermod pi -aG docker
    # newgrp docker
