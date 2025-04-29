---
title: "Manual del Proyecto"
author: "Tu Nombre"
lang: es
fontsize: 11pt
geometry: margin=2.5cm
mainfont: Arial
linkcolor: blue
---

# **Configuración del k8s con nodos worker**

![image1]( ./assets/img/01.png "k8s-nodes")

## **Pasos para realizar la configuración**

Primero necesita instalar **microk8s** en su servidor maestro y en los nodos que necesita.

Para facilitar su instalación, utilice el script [`01_install_k8s.sh`](./assets/scripts/01_install_k8s.sh) ubicado en la carpeta de `scripts/01_install_k8s.sh` para automatizar su instalación.

> La versión de microk8s que es instalará para esta configuración es `MicroK8s v1.28`

Para configurar el metallb se utilizará el gestor de paquetes de kubernetes no sporporciona `helm3`

### Configuracion de Helm3

Por defecto, ya viene habilitado helm con tras la instalación de microk8s. Si no tiene instalado este gestor de paquetes instalelo

La versión el para helm, en esta configuración es la siguiente:

![image2]( ./assets/img/version-helm.png "helm-version")

### Añadir Nodos

Dentro del nodo maestro, se debe crear un token que permitirá la vinculación entre el nodo maestro y los nodso workers , para ello ejecute el siguiente comando:

```
microk8s add-node
```

Una vez ejecutado el comando anterior, se le mostrará la siguiente información:

![image3]( ./assets/img/token-nodeworker.png "alt-img")

Utilize ese comando marcado en la imagen de arriba, en su servidor que actuará como nodo worker:

Una vez ejecutado el comando, se espera una salida como la siguiente:

![image4]( ./assets/img/output-nodeworker.png "alt-img")

Esta salida indica que los nodos han sido vinculados exitosamente al nodo master.

![image4]( ./assets/img/nodes-ready.png "alt-img")

Una vez realizada esta configuración, puedes pasar a configurar el metallb

## Configuración del `metallb`

Para poder instalar metallb realizarmos la instalación desde el repositorio oficial:
Ejecuta este comando:


```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml
```

El problema que puede sucitarse tras la configuración de metallb, es que necesite validar el webhook del controller de metallb, en ese caso deshabilitaremos `crds.validationsFailurePolicy`

```bash
helm upgrade --install metallb  metallb/metallb --create-namespace --namespace metallb-system --set crds.validationFailurePolicy=Ignore --wait
 ```

Si todo va vien verifique que los speakers esten en `Running`

![image5]( ./assets/img/get-metallb-system.png "alt-img")

Luego aplique loa configuración `IPAddressPool` y `L2Advertisement` que metallb necesita, para ello se proporciona el archivo `metallb-config.yaml`

Archivo: [`metallb-config.yaml`](./assets/yaml/metallb-config.yaml)

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default-pool
  namespace: metallb-system
spec:
  addresses:
    - 10.1.6.213-10.1.6.215 # Configure el rango de ips disponibles en su red

---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2-adv
  namespace: metallb-system
spec:
  ipAddressPools:
  - default-pool
```

Luego aplique esta configuracion del archivo con: 

```bash
kubectl apply -f metallb-config.yaml
```

Tendría que generar la siguiente salida:

```bash
ipaddresspool.metallb.io/default-pool configurated
l2advertisement.metallb.io/l2-adv configurated
```
### Configuración del Ingress

Aplique la configuración del archivo [`ingress-route.yaml`](./assets/yaml/ingress-route.yaml)

```bash
kubectl apply -f ingress.route.yaml
```

Aplique la configuración del archivo [`app-hello.yaml`](./assets/yaml/app-hello.yaml)

```bash
kubectl apply -f app-hello.yaml
```

Este archivo contiene la configuracion del `Service` y el `Deployment` necesarios para desplegar el servicio y el pod


![alt text](./assets/img/gte-allpods.png)

