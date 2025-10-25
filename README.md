# Kubernetes-Lightweight-Quickstart
Quickstart on using K3S

# Kubernetes [Lightweight] Quickstart

### Abstract

A hundred years a ago words such as computer, network,
firewall, and privacy had different connotations
than today. Even in recent decades access control was often provided
using physical constructs. Eventually controllers were introduced,
cables to terminals got longer, the Ethernet became adopted,
modems connected networks, ARPANET succeeded, and finally the Internet.
Many evolutions have occurred in software development as well. Yet most
modern access control mechanisms seem stuck in the past. Years ago, locks and keys
were used on doors to keep things from coming in and things from coming out, and most
vaults had a single door. This sounds surprising similar to how most
organizations handle Internet security. That is, most have utilize a single
device to handle Internet security. The device is a modern day equivalent of
a single access door. Everything coming in and out of a single point. It's
time to evolve and adapt. In this paper, we will share some recent
evolutions in access controls and some ideas on what may be logical
next steps.


### Contents
1. [Introduction](#introduction)
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
