# Cluster GitOps com Terraform e ArgoCD

Descrição do projeto criada com IA. ;D

Este repositório contém a configuração de infraestrutura como código (IaC) para provisionar e gerenciar um cluster Kubernetes e suas aplicações, utilizando uma abordagem GitOps.

## Introdução

O objetivo deste projeto é automatizar a criação da infraestrutura e o deploy de aplicações de forma declarativa e auditável. Todas as configurações, desde os recursos na nuvem até as aplicações no cluster, são definidas como código neste repositório. O estado desejado no Git é sincronizado continuamente com o ambiente de produção.

## Tecnologias Utilizadas

- **Terraform**: Ferramenta de IaC utilizada para provisionar e gerenciar os recursos de infraestrutura na nuvem (Rackspace, Cloudflare) e também para instalar e configurar componentes base no cluster Kubernetes.
- **Kubernetes**: Orquestrador de contêineres que hospeda as aplicações.
- **Helm**: Gerenciador de pacotes para o Kubernetes. É utilizado para empacotar, configurar e implantar aplicações e serviços no cluster, como o `ingress-nginx` e o `cert-manager`.
- **ArgoCD**: Ferramenta de entrega contínua (CD) baseada em GitOps. Ele é responsável por manter o estado do cluster sincronizado com as configurações definidas neste repositório (especificamente nos diretórios `helm/` e `argocd/`).
- **GitHub Actions**: Utilizado como plataforma de CI/CD para automatizar a execução do Terraform.
- **Cert-manager**: Adiciona certificados TLS ao cluster e os gerencia automaticamente. É configurado para emitir certificados, provavelmente usando Let's Encrypt.
- **NGINX Ingress Controller**: Atua como o ponto de entrada para o tráfego HTTP/S no cluster, roteando as requisições para os serviços corretos.

## Gerenciamento de Segredos

**Segredos NUNCA devem ser comitados diretamente neste repositório.** O gerenciamento de informações sensíveis (como tokens de API, senhas, etc.) deve seguir uma das seguintes abordagens:

1.  **Variáveis de Ambiente no CI/CD**: Os segredos são armazenados de forma segura no GitHub (em `Settings > Secrets > Actions`) e injetados como variáveis de ambiente durante a execução dos workflows do GitHub Actions. O Terraform pode então utilizá-los para provisionar os recursos.
2.  **Gestor de Segredos Externo**: Utilização de uma ferramenta dedicada como HashiCorp Vault ou o gestor de segredos do provedor de nuvem. O Terraform e as aplicações no cluster são configurados para ler os segredos diretamente dessas ferramentas.

## Processo de CI/CD

O processo de integração e entrega contínua é dividido em duas partes principais:

1.  **Provisionamento da Infraestrutura (CI com GitHub Actions)**:
    -   Alterações nos arquivos `.tf` (Terraform) são enviadas para o repositório.
    -   Ao fazer um push ou merge para a branch `main`, o workflow do GitHub Actions definido em `.github/workflows/apply.yaml` é acionado.
    -   Este workflow executa os comandos `terraform plan` e `terraform apply` para provisionar ou atualizar a infraestrutura na nuvem e no cluster Kubernetes.

2.  **Deploy das Aplicações (CD com ArgoCD)**:
    -   O Terraform provisiona o ArgoCD no cluster e o configura para monitorar este repositório Git.
    -   O `ApplicationSet` (`argocd/applicationSet.tftpl`) instrui o ArgoCD a procurar por aplicações (charts Helm) no diretório `helm/`.
    -   Quando uma alteração é feita em um dos charts (por exemplo, atualização da versão de uma imagem no `values.yaml`), o ArgoCD detecta a mudança.
    -   O ArgoCD aplica automaticamente as alterações no cluster, garantindo que o estado ativo seja sempre um reflexo do estado definido no Git.

## Como é Feito o Deploy dos Recursos

O deploy é totalmente declarativo e segue o fluxo GitOps:

1.  **Para Infraestrutura (Terraform)**:
    -   Um desenvolvedor abre um Pull Request com as alterações nos arquivos `.tf`.
    -   Após a aprovação e o merge para a branch `main`, o pipeline de CI/CD do GitHub Actions aplica as mudanças.

2.  **Para Aplicações (ArgoCD)**:
    -   Para implantar ou atualizar uma aplicação, um desenvolvedor modifica seu respectivo chart Helm no diretório `helm/`.
    -   Assim que a alteração é mesclada na branch `main`, o ArgoCD detecta a divergência entre o estado desejado (Git) e o estado atual (cluster).
    -   O ArgoCD inicia um processo de sincronização para aplicar as novas configurações, atualizando a aplicação no Kubernetes sem intervenção manual.

## Contribuição

Para contribuir com o projeto, siga os passos abaixo:

1.  **Fork**: Faça um fork deste repositório.
2.  **Branch**: Crie uma nova branch para a sua feature ou correção (`git checkout -b minha-feature`).
3.  **Commit**: Faça o commit das suas alterações (`git commit -m 'Adiciona minha feature'`).
4.  **Push**: Envie as alterações para o seu fork (`git push origin minha-feature`).
5.  **Pull Request**: Abra um Pull Request para a branch `main` do repositório original.

Aguarde a revisão e aprovação do seu Pull Request. Certifique-se de que suas alterações sigam os padrões e convenções do projeto.
