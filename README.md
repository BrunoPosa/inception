# Inception
hive school project

## Theory behind this project

### Virtual Machine (VM)
A virtual machine is a simulated computer system that runs on top of physical computer. It behaves like a separate, independent machine, even though it shares the physical resources of the computer hosting it. Here’s how it works and why it’s useful:

- Isolation: VMs are isolated environments. This means that whatever you do in a VM won’t affect your main operating system. For instance, if something goes wrong with the software in your VM, it won’t harm your main OS.
- Resource Allocation: You can allocate a certain amount of memory (RAM), CPU cores, and storage to the VM, essentially giving it its own "mini computer" within your system.
- Software Testing and Development: VMs are ideal for testing and developing software in a contained environment. You can set up specific operating systems or versions, install software, and configure settings without impacting your primary OS.
- Multiple Operating Systems: With VMs, you can run different operating systems on the same physical hardware. For example, you can run a Linux-based VM on a Windows machine or vice versa.

In this project, the VM is where I’ll install Docker and set up my containerized infrastructure. This gives me a dedicated environment for running my services without affecting my primary operating system.

### Debian
Debian is a popular Linux-based operating system known for its stability and extensive package repository. It's widely used in server environments and is the base for many other operating systems, such as Ubuntu.

Here are some key characteristics of Debian that make it suitable for this project:

- Lightweight and Minimalist: Debian is relatively lightweight, making it ideal for running Docker containers, which need efficiency to avoid using too much system memory and processing power.
- Stability: Debian is known for stability. It prioritizes reliable and secure packages over the very latest software versions, which makes it perfect for server and infrastructure use.
- Compatibility with Docker: Debian has strong support for Docker, and Docker officially provides images based on Debian for users to build on. This is why this project allows the use of either Debian or Alpine as the base for Docker containers.

In this project, I’ll use Debian as the base for my custom Docker images. This means that each container I create (e.g., for NGINX, WordPress, MariaDB) will start with a minimal Debian environment. Then, I’ll install and configure only the necessary software for each service to keep the containers lightweight and optimized.

### Container
Containers are a lightweight form of virtualization that packages software and its dependencies in a way that allows it to run consistently across different computing environments. They are similar to virtual machines (VMs) but differ in several key ways that make them more efficient and faster to start.

Here's a detailed look at what containers are, how they work, and why they’re useful:

#### What is a Container?
A container is a standalone package that includes an application and everything it needs to run, such as libraries, dependencies, and configuration files. This package is isolated from other containers and from the host system it runs on.

- Isolation: Each container runs independently of other containers and the host operating system. This isolation helps prevent conflicts between software dependencies.
- Consistency Across Environments: Containers make it easy to run the same application in any environment, whether it's on a developer's laptop, a test server, or a production server.

#### How Containers Work?
Containers are made possible by technologies in the Linux operating system, such as cgroups and namespaces, which allow processes to be isolated from each other and to have controlled access to system resources.

Here's how it works:

- Shared Operating System Kernel: Unlike VMs, containers share the host system’s kernel. They don’t need to run a full OS but instead rely on the host OS's core (kernel). This makes containers much lighter than VMs.
- File System Isolation: Each container has its own isolated file system. This file system is defined by a container image, which includes the base OS libraries, application code, and dependencies.
- Process Isolation: Containers run their own processes independently of the host system and other containers. This means a crash in one container doesn’t impact the others.

#### Containers vs. Virtual Machines

| Feature         | Containers                        | Virtual Machines |
|-----------------|-----------------------------------|------------------------------------|

| OS Dependency	  | Shares host OS kernel	          | Runs a full OS                |
| Size            |	Lightweight (megabytes)           | Heavier (gigabytes) |
| Startup Speed   |	Fast, usually seconds             | Slower, usually minutes            |
| Isolation Level |	Process and file system isolation |	Full isolation, including OS       |
| Resource Usage  |	Low	                              |High, as each VM requires a full OS |

#### Why Containers are Popular?
Containers are ideal for creating microservices architectures, where each service runs in its own container and communicates over a network. This is beneficial for:

- Application Portability: Since a container includes everything the app needs, it can run anywhere Docker or container runtimes are supported.
- Efficiency: Containers use far fewer resources than VMs, which allows for greater application density on a single host.
- Speed: Containers start quickly, making them useful for environments where apps need to be created, scaled, or torn down frequently.

#### Containers in this Project
In this project, I’ll use Docker to create and manage containers. Here’s how containers will play a role:

- Service Isolation: Each service (NGINX, WordPress, and MariaDB) will run in its own container, isolated from the others. This prevents dependency conflicts and allows for easier scaling.
- Networking: Docker will set up a virtual network so containers can communicate with each other but are isolated from external networks, except through specific entry points (e.g., NGINX on port 443).
- Persistent Storage: Containers are stateless by default, meaning data does not persist if a container is stopped. To store data persistently (like WordPress content or database), I’ll set up volumes.

#### Docker Images and Containers
In Docker, images are the blueprints of containers. An image contains the application and the dependencies it needs. When you start an image, it creates a running instance known as a container.

- Dockerfile: This is a file where you define the instructions to create an image. I’ll write Dockerfiles to specify the setup and dependencies for each of your services.
- Docker Compose: Docker Compose is a tool that lets you define and manage multi-container applications using a docker-compose.yml file. This file will allow me to configure and run all my services together with a single command.
