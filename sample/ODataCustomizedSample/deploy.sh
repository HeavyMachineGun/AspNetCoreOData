RESOURCE_GROUP=$1
WEB_APP_NAME=$2

# deploy.sh odata-services-poc poc-odata-netcore
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <resource-group> <webapp-name>"
    echo "Example: $0 my-rg my-webapp"
    echo "Please provide the resource group, web app name."
    exit 1
fi

echo "Resource Group: $RESOURCE_GROUP"
echo "Web App Name: $WEB_APP_NAME"

echo "Publishing the project..."
rm -rf publish

echo "Generating release project..."
dotnet publish -c Release -r win-x86 --self-contained -o ./publish
cd publish

echo "Zipping the project..."
zip -rq ../deploy.zip .
cd ..

echo "Deploying the project into azure..."
az webapp deployment source config-zip --resource-group "$RESOURCE_GROUP" --name "$WEB_APP_NAME" --src deploy.zip