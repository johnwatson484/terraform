#cloud-config
repo_update: true
repo_upgrade: all
packages:
 - htop
 - locales
 - ntpdate
 - ntp 
 - nfs-common
runcmd:
 - "echo ${hostname} > /etc/hostname"
 - "hostname ${hostname}"
 - "/etc/eks/bootstrap.sh --apiserver-endpoint ${eks_jenkins_cluster_endpoint} --b64-cluster-ca ${eks_jenkins_cluster_kubeconfig_certificate_authority_data} ${eks_cluster_name}" 
write_files:
  - path: /etc/ntp.conf
    permissions: 0644
    owner: root
    content: |
         driftfile /var/lib/ntp/ntp.drift
         disable monitor
         statistics loopstats peerstats clockstats
         filegen loopstats file loopstats type day enable
         filegen peerstats file peerstats type day enable
         filegen clockstats file clockstats type day enable
         server 169.254.169.123  prefer iburst
         restrict default kod notrap nomodify nopeer noquery
         restrict 10.0.0.0 mask 255.0.0.0 nomodify notrap
         restrict 127.0.0.1
         restrict ::1
         server  127.127.1.0
         fudge   127.127.1.0 stratum 10
  - path: /etc/issue
    permissions: 0640
    owner: root
    content: |
         *********************************************************************
                     WARNING - COMPUTER MISUSE ACT 1990
                  YOU WILL COMMIT A CRIMINAL OFFENCE IF YOU ACT
                OUTSIDE YOUR AUTHORITY IN RELATION TO THIS COMPUTER.
                            THE PENALTY IS
                     A FINE, IMPRISONMENT, OR BOTH.
                 IF YOU ARE ACTING OUTSIDE YOUR AUTHORITY,
                       DO NOT PROCEED ANY FURTHER.
         *********************************************************************
  - path: /etc/motd
    permissions: 0640
    owner: root
    content: |
         *********************************************************************
                     WARNING - COMPUTER MISUSE ACT 1990
                  YOU WILL COMMIT A CRIMINAL OFFENCE IF YOU ACT
                OUTSIDE YOUR AUTHORITY IN RELATION TO THIS COMPUTER.
                              THE PENALTY IS
                       A FINE, IMPRISONMENT, OR BOTH.
                   IF YOU ARE ACTING OUTSIDE YOUR AUTHORITY,
                         DO NOT PROCEED ANY FURTHER.
         *********************************************************************
  - path: /etc/securetty
    permissions: 0640
    owner: root
    content: |
         # /etc/securetty: list of terminals on which root is allowed to login.
         # See securetty(5) and login(1).
         console
         # Local X displays (allows empty passwords with pam_unix's nullok_secure)
         # ==========================================================
         #
         # TTYs sorted by major number according to Documentation/devices.txt
         #
         # ==========================================================
         # Virtual consoles
         tty1
         tty2
         tty3
         tty4
  - path: /etc/cron.allow
    permissions: 0644
    owner: root
    content: |
         ubuntu
         root
