# photoNix

## Usage (Docker)

### Shell (via docker-launcher.sh)
To run contaainer directly under shell, invoke:
```shell
./docker/docker-launcher.sh
```
Script will use path from which it was invoked as mounting point for workspace.

### VS Code (devcontainers)
It can be also run under VS Code using devcontainers extension.
To do this:
1. Open photoNix folder under VS Code.
2. Open Command Pallete (Ctrl + Shift + P)
3. Select 'Dev Containers: Reopen in Container'

## System and tools
| Component            | Version      | Note              | URL                                           |
| :------------------- | :----------- | :---------------- | :-------------------------------------------- |
| **OS**               | Ubuntu 24.04 | Base system       |                                               |
| **KLayout**          | 0.28.16      | GDS viewer/editor | https://www.klayout.de/                       |
| **klive**            | 0.4.3        | KLayout plugin    | https://github.com/gdsfactory/klive           |
| **XSection**         | 1.10         | KLayout plugin    | https://codeberg.org/klayoutmatthias/xsection |
| **SiEPIC Tools**     | 0.5.31       | KLayout plugin    | https://github.com/SiEPIC/SiEPIC-Tools        |
| **SiEPIC EBeam PDK** | 0.4.53       | KLayout plugin    | https://github.com/SiEPIC/SiEPIC_EBeam_PDK    |
| **Ansys Lumerical**  | 2026 R1      | Simulation suite  | https://ansys.synopsys.com/products/optics/   |

## Lumerical
> [!IMPORTANT]
> Currently, only Lumerical 2026 R1 has been tested and hence is considered as the only one supported.

In order to install Lumerical, place `lumerical.deb` in `secrets/` directory before starting the container.

```shell
user@host:~/photoNix/ > ls secrets
lumerical.deb
```

### Licensing
#### Using Ansys ID token

> [!IMPORTANT]
> Currently, only this form of licensing has been tested and hence is considered as the only one supported.

1. Login to your [Ansys ID account](https://id.ansys.com/).
2. Click your profile icon in top, right corner and select `Personal access tokens`
3. Click `Create Token` button. Set name to `ansys_token` and confirm with `Create` button.
4. If token has been created, you should see the pop up message.
5. Click `Download the token`. In few seconds you should get `ansys_token.json` file.
6. Move or copy this file under `secrets/` directory.
7. Once your token and installer are in place you can run the container. 

```shell
user@host:~/photoNix/ > ls secrets
ansys_token.json  lumerical.deb
```

