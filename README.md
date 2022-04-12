# QR Code generation via Azure Functions

[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnianton%2Fazure-functions-qrcode%2Fmain%2Fdeploy%2Fazure.deploy.json)


This is a templated deployment of a secure Azure architecture for hosting an Azure Function application to generate QR Codes for consumption by a public endpoint.

The architecture of the solution is as depicted on the following diagram:

![Artitectural Diagram](./assets/architecture-diagram.png?raw=true)

## The role of each component

* **Azure Function** serverless component to generate the QR Code via a GET request (returns QR Code in PNG format)
* **Application Insights** to provide monitoring and visibility for the health and performance of the Azure Function
* **CDN Profile & Endpoint** the Content Delivery Network to cache the QR Code image to the closest Point-of-Presence to the client

## Azure Function QR Code generator

A sample implementation for generating a QR code based on a GET request, containing the information of the `payload` path parameter, is also deployed as part of this repository, and the related .NET Core project is under the path `/src/QrCodeGenerator`.

**NOTE**: The Azure Function deployed also contains an access restriction to allow traffic **only** coming through the related CDN backend.

<br>

---
Based on the template repository (**[https://github.com/nianton/bicep-starter](https://github.com/nianton/azure-naming#bicep-azure-naming)**) to get started with an bicep infrastructure-as-code project, including the azure naming module to facilitate naming conventions. 

For the full reference of the supported naming for Azure resource types, head to the main module repository: **[https://github.com/nianton/azure-naming](https://github.com/nianton/azure-naming#bicep-azure-naming-module)**