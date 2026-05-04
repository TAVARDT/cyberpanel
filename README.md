# CyberPanel / OpenLiteSpeed Hardening

<div align="center">
  <p>Elite B2B Security & Tuning Configurations for CyberPanel Hosting Infrastructure.</p>
  <p>
    <a href="#-english">🇺🇸 English</a> | 
    <a href="#-português">🇧🇷 Português</a>
  </p>
</div>

---

## 🇺🇸 English

### Corporate Server Control Panel Security
This repository contains the official **TAVARDT Agency** hardening templates for bare-metal and cloud servers managed by CyberPanel (OpenLiteSpeed). While CyberPanel is extremely fast, its default configuration leaves several attack vectors open (like exposed SSH ports and Cloudflare IP spoofing). These scripts transform a basic installation into an enterprise-grade hosting node.

### Contents
- **`ols-tuning.conf`**: OpenLiteSpeed configuration guidelines to handle tens of thousands of concurrent connections (DDoS resilience) and optimize static asset caching in RAM.
- **`cloudflare-real-ip.sh`**: A critical script that forces OpenLiteSpeed to trust Cloudflare and read the real visitor's IP. Without this, your firewall will accidentally block Cloudflare during an attack, taking all your hosted websites offline.
- **`cyberpanel-hardening.sh`**: A bash execution script that fundamentally secures the server post-installation by changing the SSH port, locking down root logins, and enforcing safe PHP resource limits across all `lsphp` versions to prevent CPU exhaustion.

### Implementation Guide
1. Execute `cyberpanel-hardening.sh` immediately after installing CyberPanel on a fresh OS. Make sure you note down the new SSH port, or you will be locked out of your server.
2. Run `cloudflare-real-ip.sh` if your client websites use Cloudflare DNS proxying.

### Contact & Services
Looking for elite B2B infrastructure and high-ticket digital engineering?
- **Website:** [ag.tavardt.com](https://ag.tavardt.com/)
- **Email:** contact@tavardt.com

---

## 🇧🇷 Português

### Segurança Corporativa de Servidores
Este repositório contém os templates oficiais de "Hardening" (blindagem) da **TAVARDT** para servidores dedicados e cloud gerenciados pelo CyberPanel (OpenLiteSpeed). Embora o CyberPanel seja extremamente rápido, sua configuração padrão deixa vários vetores de ataque abertos (como portas SSH expostas e falhas na leitura de IP da Cloudflare). Estes scripts transformam uma instalação básica em um nó de hospedagem corporativo.

### Conteúdo
- **`ols-tuning.conf`**: Diretrizes de configuração do OpenLiteSpeed para lidar com dezenas de milhares de conexões simultâneas (resiliência contra DDoS) e otimizar o cache de arquivos estáticos na memória RAM.
- **`cloudflare-real-ip.sh`**: Um script crítico que força o OpenLiteSpeed a confiar na Cloudflare e ler o IP real do visitante. Sem isso, o firewall do seu servidor bloqueará acidentalmente a própria Cloudflare durante um ataque, derrubando todos os sites hospedados.
- **`cyberpanel-hardening.sh`**: Um script Bash executável que protege fundamentalmente o servidor logo após a instalação, alterando a porta SSH, bloqueando logins root diretos e impondo limites seguros de recursos PHP em todas as versões do `lsphp` para evitar exaustão de CPU.

### Guia de Implementação
1. Execute `cyberpanel-hardening.sh` imediatamente após instalar o CyberPanel em um SO limpo. Certifique-se de anotar a nova porta SSH, caso contrário, você perderá o acesso ao seu próprio servidor.
2. Execute `cloudflare-real-ip.sh` se os sites dos seus clientes usarem proxy de DNS da Cloudflare.

### Contato & Serviços
Procurando por infraestrutura B2B de elite e engenharia digital high-ticket?
- **Site:** [ag.tavardt.com/br/](https://ag.tavardt.com/br/)
- **E-mail:** contato@tavardt.com
