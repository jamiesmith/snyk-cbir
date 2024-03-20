FROM node as build-stage
RUN git clone --single-branch https://github.com/datocms/snipcart-gatsby-demo.git /app
WORKDIR /app
RUN git switch --detach b93fcf6
RUN npm install --production && npm run-script build

FROM example.com/goldenimages/nodejs:0.0.1
LABEL maintainer="Snyk Container Field Specialist"

# copy package manifest files to allow Snyk to detect app vulns
COPY --from=build-stage /app/*.json /app/

# copy static Gatsby assets
COPY --from=build-stage /app/public /app/public

EXPOSE 8000
CMD ["npx", "--yes", "--production", "http-server", "--port", "8000"]
