---
tags:
  - Geddes
authors:
  - jin456
  - goughes
  - fbakhit
search:
  boost: 2
---

# How to Request a TLS Certificate on the Geddes Cluster

## 1. Do I need to request a certificate?

Geddes has a wildcard certificate covering hostnames such as `myapp.geddes.rcac.purdue.edu`.

If your hostname is covered by this certificate, you do **not** need to request a separate certificate.

Examples:

| Hostname | Request needed? |
|---|---|
| `my-app.geddes.rcac.purdue.edu` | No — covered by the wildcard certificate |
| `grafana.geddes.rcac.purdue.edu` | No — covered by the wildcard certificate |
| `my-app.example.com` | May need a separate certificate |
| `my-app.rcac.purdue.edu` | May need a separate certificate |

The wildcard covers one hostname level under `geddes.rcac.purdue.edu`. It does not cover deeper names such as `api.my-app.geddes.rcac.purdue.edu`.

If you are unsure whether your hostname is covered, contact RCAC staff before submitting a request.

## 2. Important requirements

- **All certificate requests are subject to review.** RCAC staff may approve or deny any request.
- **Validate your domain name before requesting a certificate.** You are responsible for ensuring that you own or are authorized to use the requested domain and that its DNS configuration is correct.
- **Geddes domains:** Hostnames covered by the existing wildcard certificate, such as `myapp.geddes.rcac.purdue.edu`, do not require a separate certificate request.

### Requesting a certificate for a non-Geddes domain

For any domain that is not covered by `*.geddes.rcac.purdue.edu`, follow these steps before creating a certificate request on Geddes.

1. **Verify domain ownership.** If you are requesting a certificate for an external domain, such as `example.com` or `example.org`, make sure you own the domain or have authorization from its owner to use it.
2. **Contact the Purdue Network team first.** Email it@purdue.edu before adding the domain to your Geddes application configuration or requesting a certificate.
3. **Request the required DNS configuration.** Ask the Purdue Network team at it@purdue.edu to configure the appropriate DNS **A record** for your domain to point to the Geddes endpoint IP, as directed by the Network team.
4. **Wait for confirmation.** Do not proceed until the Purdue Network team has reviewed and completed the required DNS configuration.
5. **Create your certificate request.** After the Network team confirms completion, configure your application with the approved domain and follow this guide to request a certificate.

**Important:** Do not add an external domain to your Geddes application or submit a certificate request before completing the Purdue Network team's review and DNS configuration process.

If you have questions about domain ownership, DNS configuration, or certificate requests, contact rcac-help@purdue.edu.


## 3. Create your certificate request

Create a file named `certificate.yaml` and copy the example below.

Replace the example values with your own namespace and DNS name.

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: my-app-tls
  namespace: my-namespace
  labels:
    network: private
spec:
  secretName: my-app-tls
  issuerRef:
    name: certinext-acme-issuer
    kind: ClusterIssuer
    group: cert-manager.io
  dnsNames:
    - my-app.example.com
```

Update these values:

- `metadata.name`: A name for your certificate.
- `metadata.namespace`: Your Geddes Kubernetes namespace.
- `spec.secretName`: The name for the Secret that will store your certificate and private key.
- `network`: Use `private` or `public`, depending on your application's endpoint.
- `dnsNames`: Your actual DNS name.


## 4. Submit your request

Run:

```bash
kubectl apply -f certificate.yaml
```

Check the certificate:

```bash
kubectl get certificate -n my-namespace
```

Replace `my-namespace` with your actual namespace.

## 5. Wait for approval

RCAC staff must review and approve your certificate request before the certificate can be issued.
After submitting your request, you may email rcac-help@purdue.edu to notify RCAC staff. If your request remains pending for several days, you may also follow up by email to check its status.

Check the request status:

```bash
kubectl get certificaterequest -n my-namespace
```

A request may remain pending while waiting for approval. Please do not repeatedly submit the same request.

## 6. Verify your certificate

After approval and successful issuance, cert-manager creates the TLS Secret.

Check the certificate and Secret:

```bash
kubectl get certificate my-app-tls -n my-namespace
kubectl get secret my-app-tls -n my-namespace
```

The Secret should have type `kubernetes.io/tls` and contain the certificate and private key.

Your application can then reference this Secret in its Ingress, Gateway, or application configuration, as appropriate.

**Security:** Never share the private key or commit it to source control.

## 7. Need help?

If your request is pending, fails, or you have questions about whether a certificate is needed, contact **rcac-help@purdue.edu**.

When asking for help, include your Kubernetes namespace, requested DNS name, certificate name, and any relevant error messages. Do not send your private key.