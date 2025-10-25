# Kubernetes-Lightweight-Quickstart
Quickstart on using K3S

### Abstract

Throughout my career there has been endless change and as a result endless learning.
I enjoy the challenge. Recently, I decided to refine my Infrastructure as Code (IaC)
skills by creating a project with the intent to write a simple how-to mixing Terradata (OpenTofu)
with KinD (Kubernetes in Docker) and a deployment of microservice using OpenFaaS Community Edition (CE).
The end result is documented at https://fraserswaxway.github.io/tofu-quick-start/ and all the files are
at https://github.com/fraserswaxway/tofu-quick-start. Most [somewhat] technical people should be
able to use the provided files and see a result in around 30 minutes.

### Contents
1. [Environment](#environment)
2. [Folder and Files](#folder)
3. [HashiCorp Configuration Language (HCL)](#hcl)<br>
   3.1 [Functions](#functions)<br>
   3.2 [Providers](#providers)<br>
   3.3 [Variables](#variables)<br>
   3.4 [Data](#data)<br>
   3.5 [Resource](#resource)<br>
4. [Command Line Interface (CLI) - Apply](#apply)
5. [cURL Validation](#curl)
6. [Command Line Interface (CLI) - Destroy](#destroy)
7. [Tips](#tips)


### 1. Introduction <a id="introduction"/>

Most human communication is sensory based. Block senses and
most communication is prevented. Many organizations practice
blocking senses to protect information. Most are familiar
the use of distance, walls, rooms, doors, curtains,
and soundproofing as physical barriers. Languages and codes
can also be barriers.

![OSI 7 Layers](https://miro.medium.com/v2/resize:fit:720/format:webp/0*_APAwpghit64dMkW.png)


References
https://kubernetes.io/docs/concepts/overview/

### About the Author

Stuart Fraser has a Master of Science in Computer Science from Old Dominion University and is a
consulting Principal Architect at [Axway](https://axway.com/).

### Acknowledgements

Special thanks to [Axway](https://axway.com/) for affording and enabling skills development.

