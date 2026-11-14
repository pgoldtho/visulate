# Database Fresh Install Setup

## Functional Overview
This directory contains foundational documentation for setting up a new database server environment from scratch for the Visulate application. It provides detailed specifications for server hardware, operating system installation, network configuration, and disk partitioning, ensuring a consistent and robust base for database deployments. This information is crucial for provisioning new production or development database instances.

## Files & Component Responsibilities
| File Name | Description |
| :-------- | :---------- |
| `SETUP.txt` | This comprehensive text file outlines the exact steps and specifications required to provision a new database server. It details hardware specifications (CPU, Memory, Hard Drive configuration, RAID), operating system installation (Oracle Linux / CentOS), kernel updates, network setup (DNS client), and disk preparation (mounting SSD partitions). It serves as a manual for system administrators to build the underlying infrastructure before any database software is installed. |

## Database Dependencies & Interactions
The `SETUP.txt` file does not contain code that directly interacts with a database. Instead, it provides the critical, low-level instructions for *creating* the server environment upon which a Visulate database instance will eventually be installed and run. Therefore, it is a foundational prerequisite for all database operations and ensures the correct infrastructure is in place to support the Visulate database.

## Maintenance & Modernization Notes
The `SETUP.txt` file details a setup based on specific technologies like CentOS 6 / Oracle Linux 6 and particular kernel versions. When considering refactoring or modernizing, the following points should be addressed:
*   **Operating System Updates:** Update the OS installation steps and recommendations to modern, supported versions (e.g., Oracle Linux 8/9, Rocky Linux 8/9, or suitable cloud-based Linux distributions).
*   **Hardware Specifications:** Review and update hardware recommendations based on current best practices, virtualization, or cloud instance types.
*   **Automation:** Manual setup steps should ideally be replaced or supplemented by infrastructure-as-code tools (e.g., Ansible, Terraform, cloud-init scripts) to ensure reproducibility, consistency, and speed in provisioning new environments.
*   **Disk Configuration:** The disk mounting and filesystem setup (ext3) might need modernization to newer filesystems (e.g., XFS) and potentially different partitioning strategies or logical volume management (LVM) depending on performance and flexibility requirements.
*   **Cloud Agnostic:** Consider if these setup steps can be adapted for common cloud providers (AWS, Azure, GCP) where server provisioning and storage are often handled differently.
