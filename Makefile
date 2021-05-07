# Builds the website
all:
	hugo --minify

# Deploy to its server
deploy:
	rsync --delete -r public/ iron40@s.doycho.com:/var/www/listen-to-euterpe.eu/public/

# Start a development server
serve:
	hugo server -D --disableFastRender
