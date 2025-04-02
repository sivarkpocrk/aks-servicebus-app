# Use a lightweight base image with Terraform
FROM hashicorp/terraform:1.5.7

# Install Azure CLI
RUN apk update && \
    apk add --no-cache curl bash jq && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Set the working directory inside the container
WORKDIR /app

# Copy Terraform files to the container
COPY . .

# Run Azure login script (entrypoint)
COPY azure-login.sh /usr/local/bin/azure-login.sh
RUN chmod +x /usr/local/bin/azure-login.sh

# Set the entrypoint to the Azure login script
ENTRYPOINT ["/usr/local/bin/azure-login.sh"]
