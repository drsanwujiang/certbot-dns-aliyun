# Alibaba Cloud DNS Authenticator for Certbot

Certbot DNS validation hook scripts using Alibaba Cloud (Aliyun).

## Install

1. Install Alibaba Cloud CLI

   ```shell
   wget https://aliyuncli.alicdn.com/aliyun-cli-linux-latest-amd64.tgz
   tar xzvf aliyun-cli-linux-latest-amd64.tgz
   cp aliyun /usr/local/bin
   rm aliyun
   ```

2. Configure Alibaba Cloud CLI

   ```shell
   aliyun configure --profile certbot
   ```

   Follow the interactive process to configure credentials.

   ```
   Configuring profile 'certbot' in 'AK' authenticate mode...
   Access Key Id []: <Your Access Key Id>
   Access Key Secret []: <Your Access Key Secret>
   Default Region Id []: cn-hongkong
   Default Output Format [json]: json (Only support json)
   Default Language [zh|en] en:
   Saving profile[certbot] ...Done.
   ```

3. Install DNS Plugin

   ```shell
   wget https://raw.githubusercontent.com/drsanwujiang/certbot-dns-aliyun/main/alidns-auth.sh
   wget https://raw.githubusercontent.com/drsanwujiang/certbot-dns-aliyun/main/alidns-cleanup.sh
   chmod +x alidns-auth.sh
   chmod +x alidns-cleanup.sh
   ```

## Usage

Assume the scripts are located in the */root* directory.

1. Obtain Certificates

   ```shell
   certbot certonly -d *.example.com --manual --preferred-challenges dns --manual-auth-hook "/root/alidns-auth.sh" --manual-cleanup-hook "/root/alidns-cleanup.sh"
   ```

2. Renew certificates

   ```shell
   certbot renew --manual --preferred-challenges dns --manual-auth-hook "/root/alidns-auth.sh" --manual-cleanup-hook "/root/alidns-cleanup.sh"
   ```

   Use `--deploy-hook` option to automatically reload Nginx/Apache after a successful renewal.

   ```shell
   certbot renew --manual --preferred-challenges dns --manual-auth-hook "/root/alidns-auth.sh" --manual-cleanup-hook "/root/alidns-cleanup.sh" --deploy-hook "systemctl reload nginx"
   ```

3. Automated Renewals

   ```shell
   crontab -e
   ```

   Add a cron job.

   ```
   0 0 1,15 * * certbot renew --manual --preferred-challenges dns --manual-auth-hook "/root/alidns-auth.sh" --manual-cleanup-hook "/root/alidns-cleanup.sh" --deploy-hook "systemctl reload nginx"
   ```

   It will automatically check and renew the certificates on the 1st and 15th of every month.
