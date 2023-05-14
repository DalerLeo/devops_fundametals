# Build for dev in order to have dev-dependencies like nest
FROM node:alpine As development

WORKDIR /app

# A wildcard is used to ensure copying both package.json AND package-lock.json (when available).
# Copying this first prevents re-running npm install on every code change.
COPY --chown=node:node package*.json ./

# Install app dependencies
RUN npm ci

# Bundle app source
COPY --chown=node:node . .

USER node


# Build for production

FROM node:18-alpine As build

WORKDIR /app

COPY --chown=node:node package*.json ./

# In order to run `npm run build` we need access to the Nest CLI which is a dev dependency.
COPY --chown=node:node --from=development /app/node_modules ./node_modules

COPY --chown=node:node . .

RUN npm run build

ENV NODE_ENV production

# Re install node_modules to install only-production packages
RUN npm ci --only=production && npm cache clean --force

USER node

# Production
FROM node:18-alpine As production

# Copy the bundled code from the build stage to the production image
COPY --chown=node:node --from=build /app/node_modules ./node_modules
COPY --chown=node:node --from=build /app/dist ./dist

# Start the server using the production build
CMD [ "node", "dist/main.js" ]
