# DevOps Practice

## Проект: Packer + Ansible для автоматизации создания образов ВМ

Автоматизация создания образа виртуальной машины с Flask-приложением, Nginx и PostgreSQL в Yandex Cloud.

### Демо

**Flask Task Manager:** http://51.250.84.147

### Быстрый запуск

1. **Установка зависимостей:**
```bash
brew install ansible
```

2. **Настройка Yandex Cloud:**
```bash
export YC_TOKEN=$(yc iam create-token)
```

3. **Сборка образа:**
```bash
packer init ubuntu.pkr.hcl
packer build -var-file="variables.pkrvars.hcl" ubuntu.pkr.hcl
```

4. **Создание ВМ из образа:**
```bash
yc compute instance create \
  --name flask-app-vm \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-family=ubuntu-flask-app \
  --ssh-key ~/.ssh/id_rsa.pub
```
