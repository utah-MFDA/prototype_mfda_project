

import docker



docker_pnr_image = "bgoenner/mfda_pnr_cp:latest"
docker_sim_image = "bgoenner/mfda_xyce:latest"

def script_init():
    
    # get images
    client = docker.from_env()

    client.images.get(docker_pnr_image)
    client.images.get(docker_sim_image)

    # build library


if __name__ == "__main__":

    pass
